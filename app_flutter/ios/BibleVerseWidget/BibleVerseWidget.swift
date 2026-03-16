import WidgetKit
import SwiftUI

// MARK: - Timeline Provider

struct BibleVerseProvider: TimelineProvider {
    let appGroupId = "group.ee.bikain.bibliachat"

    func placeholder(in context: Context) -> BibleVerseEntry {
        BibleVerseEntry(
            date: Date(),
            verseText: "El Señor es mi pastor; nada me falta.",
            verseRef: "Salmos 23:1"
        )
    }

    func getSnapshot(in context: Context, completion: @escaping (BibleVerseEntry) -> Void) {
        completion(getEntryForDate(Date()))
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<BibleVerseEntry>) -> Void) {
        // Generate entries for the next 24 hours (one per hour)
        var entries: [BibleVerseEntry] = []
        let calendar = Calendar.current
        let now = Date()

        // Current hour entry
        entries.append(getEntryForDate(now))

        // Pre-generate next 23 hours so widget never shows stale data
        for hourOffset in 1...23 {
            if let futureDate = calendar.date(byAdding: .hour, value: hourOffset, to: now) {
                let roundedDate = calendar.nextDate(
                    after: calendar.date(byAdding: .hour, value: hourOffset - 1, to: now)!,
                    matching: DateComponents(minute: 0),
                    matchingPolicy: .nextTime
                ) ?? futureDate
                entries.append(getEntryForDate(roundedDate))
            }
        }

        // Refresh timeline after 24 hours
        let refreshDate = calendar.date(byAdding: .hour, value: 24, to: now)
            ?? now.addingTimeInterval(86400)

        let timeline = Timeline(entries: entries, policy: .after(refreshDate))
        completion(timeline)
    }

    /// Calculate the verse for a specific date/hour independently (no app needed).
    /// Mirrors the Flutter logic in widget_service.dart `_getVerseForCurrentHour()`.
    private func getEntryForDate(_ date: Date) -> BibleVerseEntry {
        let verses = loadVerses()

        guard !verses.isEmpty else {
            return BibleVerseEntry(
                date: date,
                verseText: "El Señor es mi pastor; nada me falta.",
                verseRef: "Salmos 23:1"
            )
        }

        let calendar = Calendar.current
        let dayOfYear = calendar.ordinality(of: .day, in: .year, for: date) ?? 1
        let year = calendar.component(.year, from: date)
        let hour = calendar.component(.hour, from: date)

        // Same seed algorithm as Flutter: Random(dayOfYear * 1000 + year)
        let seed = dayOfYear * 1000 + year
        let shuffledIndices = seededShuffle(count: verses.count, seed: seed)
        let index = shuffledIndices[hour % shuffledIndices.count]

        let verse = verses[index]
        return BibleVerseEntry(
            date: date,
            verseText: verse.text,
            verseRef: verse.ref
        )
    }

    /// Load verses from App Group UserDefaults (synced by Flutter).
    /// Falls back to Flutter-pushed single verse if JSON not available.
    private func loadVerses() -> [Verse] {
        let userDefaults = UserDefaults(suiteName: appGroupId)

        // Try to load full verses JSON (synced by Flutter on app open)
        if let jsonString = userDefaults?.string(forKey: "verses_json"),
           let data = jsonString.data(using: .utf8),
           let decoded = try? JSONDecoder().decode([Verse].self, from: data) {
            return decoded
        }

        return []
    }

    /// Deterministic shuffle using a simple hash-based index selection.
    /// Produces a consistent verse for each (day, hour) combination.
    private func seededShuffle(count: Int, seed: Int) -> [Int] {
        var indices = Array(0..<count)
        var state = UInt64(abs(seed))

        // Fisher-Yates shuffle with simple LCG
        for i in stride(from: count - 1, through: 1, by: -1) {
            state = state &* 6364136223846793005 &+ 1442695040888963407
            let j = Int(state >> 33) % (i + 1)
            indices.swapAt(i, j)
        }

        return indices
    }
}

/// Verse model for JSON decoding
struct Verse: Codable {
    let ref: String
    let text: String
}

// MARK: - Entry

struct BibleVerseEntry: TimelineEntry {
    let date: Date
    let verseText: String
    let verseRef: String
}

// MARK: - Color Palette

extension Color {
    static let widgetGradientStart = Color(red: 0.16, green: 0.22, blue: 0.42)   // Deep navy blue
    static let widgetGradientMid = Color(red: 0.22, green: 0.28, blue: 0.52)     // Medium blue
    static let widgetGradientEnd = Color(red: 0.30, green: 0.25, blue: 0.50)     // Purple-blue
    static let widgetGold = Color(red: 0.83, green: 0.69, blue: 0.22)            // #D4AF37
    static let widgetGoldLight = Color(red: 0.91, green: 0.79, blue: 0.40)       // #E8C967
}

// MARK: - Widget Views

/// Lock Screen widget (iOS 16+ accessoryRectangular)
struct LockScreenVerseView: View {
    let entry: BibleVerseEntry

    var body: some View {
        VStack(alignment: .leading, spacing: 1) {
            Text(entry.verseText)
                .font(.system(size: 11, weight: .medium))
                .lineLimit(3)
                .minimumScaleFactor(0.8)
            Text(entry.verseRef)
                .font(.system(size: 9, weight: .light))
                .foregroundColor(.secondary)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}

/// Home Screen small widget
struct SmallVerseView: View {
    let entry: BibleVerseEntry

    var body: some View {
        ZStack {
            // Background gradient
            LinearGradient(
                gradient: Gradient(colors: [
                    Color.widgetGradientStart,
                    Color.widgetGradientMid,
                    Color.widgetGradientEnd
                ]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )

            // Decorative circle (subtle)
            Circle()
                .fill(Color.white.opacity(0.05))
                .frame(width: 120, height: 120)
                .offset(x: 50, y: -40)

            // Content
            VStack(alignment: .leading, spacing: 6) {
                // Header
                HStack(spacing: 4) {
                    Image(systemName: "book.closed.fill")
                        .font(.system(size: 10))
                        .foregroundColor(Color.widgetGoldLight)
                    Text("VERSÍCULO")
                        .font(.system(size: 9, weight: .bold))
                        .foregroundColor(Color.widgetGoldLight)
                        .tracking(1)
                }

                // Verse text
                Text(entry.verseText)
                    .font(.system(size: 13, weight: .semibold, design: .serif))
                    .foregroundColor(.white)
                    .lineLimit(4)
                    .minimumScaleFactor(0.7)

                // Reference
                Text(entry.verseRef)
                    .font(.system(size: 10, weight: .medium))
                    .foregroundColor(Color.white.opacity(0.6))
            }
            .padding(14)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
    }
}

/// Home Screen medium widget
struct MediumVerseView: View {
    let entry: BibleVerseEntry

    var body: some View {
        ZStack {
            // Background gradient
            LinearGradient(
                gradient: Gradient(colors: [
                    Color.widgetGradientStart,
                    Color.widgetGradientMid,
                    Color.widgetGradientEnd
                ]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )

            // Decorative circles (subtle depth)
            Circle()
                .fill(Color.white.opacity(0.04))
                .frame(width: 200, height: 200)
                .offset(x: 120, y: -60)

            Circle()
                .fill(Color.white.opacity(0.03))
                .frame(width: 150, height: 150)
                .offset(x: -80, y: 70)

            // Content
            VStack(alignment: .leading, spacing: 8) {
                // Header bar
                HStack {
                    HStack(spacing: 6) {
                        Image(systemName: "book.closed.fill")
                            .font(.system(size: 11))
                            .foregroundColor(Color.widgetGoldLight)
                        Text("VERSÍCULO DE LA HORA")
                            .font(.system(size: 10, weight: .bold))
                            .foregroundColor(Color.widgetGoldLight)
                            .tracking(1.0)
                    }

                    Spacer()

                    // Cross icon
                    Image(systemName: "cross.fill")
                        .font(.system(size: 12))
                        .foregroundColor(Color.white.opacity(0.4))
                }

                // Verse text — big and prominent
                Text("\u{201C}\(entry.verseText)\u{201D}")
                    .font(.system(size: 15, weight: .semibold, design: .serif))
                    .foregroundColor(.white)
                    .lineLimit(3)
                    .minimumScaleFactor(0.75)

                // Reference with subtle gold accent
                HStack(spacing: 6) {
                    RoundedRectangle(cornerRadius: 1)
                        .fill(Color.widgetGold)
                        .frame(width: 16, height: 2)
                    Text(entry.verseRef)
                        .font(.system(size: 11, weight: .medium))
                        .foregroundColor(Color.white.opacity(0.7))
                }
            }
            .padding(16)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
    }
}

// MARK: - Widget Configuration

struct BibleVerseWidget: Widget {
    let kind: String = "BibleVerseWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: BibleVerseProvider()) { entry in
            if #available(iOS 17.0, *) {
                BibleVerseWidgetEntryView(entry: entry)
                    .containerBackground(for: .widget) {
                        LinearGradient(
                            gradient: Gradient(colors: [
                                Color.widgetGradientStart,
                                Color.widgetGradientMid,
                                Color.widgetGradientEnd
                            ]),
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    }
            } else {
                BibleVerseWidgetEntryView(entry: entry)
            }
        }
        .configurationDisplayName("Versículo de la hora")
        .description("Un versículo bíblico inspirador que cambia cada hora.")
        .supportedFamilies(supportedFamilies)
    }

    private var supportedFamilies: [WidgetFamily] {
        var families: [WidgetFamily] = [
            .systemSmall,
            .systemMedium,
        ]
        if #available(iOS 16.0, *) {
            families.append(.accessoryRectangular)
        }
        return families
    }
}

/// Adapter view that picks the right layout based on widget family
struct BibleVerseWidgetEntryView: View {
    @Environment(\.widgetFamily) var family
    let entry: BibleVerseEntry

    var body: some View {
        switch family {
        case .accessoryRectangular:
            LockScreenVerseView(entry: entry)
        case .systemSmall:
            SmallVerseView(entry: entry)
        case .systemMedium:
            MediumVerseView(entry: entry)
        default:
            SmallVerseView(entry: entry)
        }
    }
}

// MARK: - Widget Bundle

@main
struct BibleVerseWidgetBundle: WidgetBundle {
    var body: some Widget {
        BibleVerseWidget()
    }
}
