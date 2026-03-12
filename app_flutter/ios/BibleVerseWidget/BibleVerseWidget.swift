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
        completion(getEntry())
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<BibleVerseEntry>) -> Void) {
        let entry = getEntry()

        // Update every hour (at the start of next hour)
        let calendar = Calendar.current
        let nextHour = calendar.nextDate(
            after: Date(),
            matching: DateComponents(minute: 0),
            matchingPolicy: .nextTime
        ) ?? Date().addingTimeInterval(3600)

        let timeline = Timeline(entries: [entry], policy: .after(nextHour))
        completion(timeline)
    }

    private func getEntry() -> BibleVerseEntry {
        let userDefaults = UserDefaults(suiteName: appGroupId)
        let text = userDefaults?.string(forKey: "verse_text")
            ?? "El Señor es mi pastor; nada me falta."
        let ref = userDefaults?.string(forKey: "verse_ref")
            ?? "Salmos 23:1"

        return BibleVerseEntry(
            date: Date(),
            verseText: text,
            verseRef: ref
        )
    }
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
            VStack(alignment: .leading, spacing: 4) {
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

                Spacer()

                // Verse text
                Text(entry.verseText)
                    .font(.system(size: 13, weight: .semibold, design: .serif))
                    .foregroundColor(.white)
                    .lineLimit(4)
                    .minimumScaleFactor(0.7)

                Spacer()

                // Reference
                Text(entry.verseRef)
                    .font(.system(size: 10, weight: .medium))
                    .foregroundColor(Color.white.opacity(0.6))
            }
            .padding(14)
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
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
            VStack(alignment: .leading, spacing: 0) {
                // Header bar
                HStack {
                    HStack(spacing: 6) {
                        Image(systemName: "book.closed.fill")
                            .font(.system(size: 11))
                            .foregroundColor(Color.widgetGoldLight)
                        Text("VERSÍCULO DEL DÍA")
                            .font(.system(size: 10, weight: .bold))
                            .foregroundColor(Color.widgetGoldLight)
                            .tracking(1.2)
                    }

                    Spacer()

                    // Cross icon
                    Image(systemName: "cross.fill")
                        .font(.system(size: 12))
                        .foregroundColor(Color.white.opacity(0.4))
                }

                Spacer()

                // Verse text — big and prominent
                Text("\u{201C}\(entry.verseText)\u{201D}")
                    .font(.system(size: 15, weight: .semibold, design: .serif))
                    .foregroundColor(.white)
                    .lineLimit(3)
                    .minimumScaleFactor(0.75)

                Spacer()

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
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
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
                    .containerBackground(.fill.tertiary, for: .widget)
            } else {
                BibleVerseWidgetEntryView(entry: entry)
            }
        }
        .configurationDisplayName("Versículo del día")
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
