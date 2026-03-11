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

// MARK: - Widget Views

/// Lock Screen widget (iOS 16+ accessoryRectangular)
struct LockScreenVerseView: View {
    let entry: BibleVerseEntry

    var body: some View {
        VStack(alignment: .leading, spacing: 2) {
            Text(entry.verseText)
                .font(.system(size: 12, weight: .medium))
                .lineLimit(3)
                .minimumScaleFactor(0.8)
            Text(entry.verseRef)
                .font(.system(size: 10, weight: .light))
                .foregroundColor(.secondary)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}

/// Home Screen small widget
struct SmallVerseView: View {
    let entry: BibleVerseEntry

    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            Image(systemName: "book.closed.fill")
                .font(.system(size: 14))
                .foregroundColor(.orange)

            Text(entry.verseText)
                .font(.system(size: 13, weight: .medium))
                .lineLimit(5)
                .minimumScaleFactor(0.7)

            Spacer()

            Text(entry.verseRef)
                .font(.system(size: 11, weight: .light))
                .foregroundColor(.secondary)
        }
        .padding(12)
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
        .background(
            LinearGradient(
                gradient: Gradient(colors: [
                    Color(red: 0.96, green: 0.97, blue: 1.0),
                    Color.white
                ]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        )
    }
}

/// Home Screen medium widget
struct MediumVerseView: View {
    let entry: BibleVerseEntry

    var body: some View {
        HStack(spacing: 12) {
            VStack {
                Image(systemName: "book.closed.fill")
                    .font(.system(size: 24))
                    .foregroundColor(.orange)
            }
            .frame(width: 44)

            VStack(alignment: .leading, spacing: 4) {
                Text(entry.verseText)
                    .font(.system(size: 14, weight: .medium))
                    .lineLimit(4)
                    .minimumScaleFactor(0.8)

                Text(entry.verseRef)
                    .font(.system(size: 12, weight: .light))
                    .foregroundColor(.secondary)
            }

            Spacer()
        }
        .padding(14)
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
        .background(
            LinearGradient(
                gradient: Gradient(colors: [
                    Color(red: 0.96, green: 0.97, blue: 1.0),
                    Color.white
                ]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        )
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
