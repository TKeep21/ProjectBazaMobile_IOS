# ADR-007: Core Framework Target

## Status

Accepted

## Context

В критериях оценки отдельно отмечено разделение на модули и компоненты. Одних папок достаточно для навигации по коду, но они не защищают core-логику от случайной зависимости на UI.

## Decision

Добавлен отдельный Xcode framework target `HWmobileCore`.

В `HWmobileCore` вынесены:

- модели задач и новостей
- бизнес-логика задач: `TaskStore`, `TaskListQuery`, `TaskAnalytics`
- файловое хранение задач: `TaskFileStore`
- DTO-маппинг новостей и демо-данные

App target `HWmobile` импортирует `HWmobileCore` и содержит SwiftUI-экраны, view models и платформенный код.

## Consequences

Core-логика собирается отдельным модулем и может тестироваться без SwiftUI-экранов. Это делает зависимости понятнее и помогает объяснить архитектуру на защите.

Swift Package пока не используется, потому что для учебного iOS-проекта Xcode framework target проще открыть, собрать и показать в Xcode.
