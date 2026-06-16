import Foundation

public enum NewsDemoData {
    nonisolated public static let articles: [NewsArticleDisplay] = [
        NewsArticleDisplay(
            id: "demo-mobile-architecture",
            title: "Мобильное приложение получило тестируемую архитектуру",
            abstractText: "Бизнес-логика задач вынесена из SwiftUI-экранов, а ключевые сценарии покрыты unit-тестами.",
            sourceLabel: "Demo News — Mobile",
            publishedAt: Date(timeIntervalSince1970: 1_781_500_000),
            imageURL: nil
        ),
        NewsArticleDisplay(
            id: "demo-task-analytics",
            title: "В задачах появились фильтры и статистика",
            abstractText: "Пользователь может искать задачи, переключать фильтры, сортировать список и видеть прогресс выполнения.",
            sourceLabel: "Demo News — Productivity",
            publishedAt: Date(timeIntervalSince1970: 1_781_480_000),
            imageURL: nil
        ),
        NewsArticleDisplay(
            id: "demo-cache-fallback",
            title: "Кэш помогает приложению работать устойчивее",
            abstractText: "Экран новостей сначала показывает сохраненные данные, а при отсутствии API-ключа использует демо-режим.",
            sourceLabel: "Demo News — Engineering",
            publishedAt: Date(timeIntervalSince1970: 1_781_460_000),
            imageURL: nil
        )
    ]
}
