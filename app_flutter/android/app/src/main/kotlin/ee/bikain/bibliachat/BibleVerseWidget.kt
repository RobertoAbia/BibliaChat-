package ee.bikain.bibliachat

import android.appwidget.AppWidgetManager
import android.content.Context
import android.content.SharedPreferences
import android.widget.RemoteViews
import es.antonborri.home_widget.HomeWidgetProvider

/**
 * Android Home Screen widget that displays a Bible verse.
 *
 * Extends HomeWidgetProvider from the home_widget package.
 * Data is saved from Flutter via HomeWidget.saveWidgetData().
 *
 * Data keys:
 * - verse_text: The verse content in modern Spanish
 * - verse_ref: The Bible reference (e.g. "Salmos 23:1")
 */
class BibleVerseWidget : HomeWidgetProvider() {

    override fun onUpdate(
        context: Context,
        appWidgetManager: AppWidgetManager,
        appWidgetIds: IntArray,
        widgetData: SharedPreferences
    ) {
        appWidgetIds.forEach { widgetId ->
            val views = RemoteViews(context.packageName, R.layout.bible_verse_widget)

            val verseText = widgetData.getString(
                "verse_text",
                "El Señor es mi pastor; nada me falta."
            ) ?: "El Señor es mi pastor; nada me falta."

            val verseRef = widgetData.getString(
                "verse_ref",
                "Salmos 23:1"
            ) ?: "Salmos 23:1"

            views.setTextViewText(R.id.verse_text, verseText)
            views.setTextViewText(R.id.verse_ref, verseRef)

            appWidgetManager.updateAppWidget(widgetId, views)
        }
    }
}
