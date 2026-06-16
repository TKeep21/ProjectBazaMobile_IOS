# ADR-002: Task Core Logic In TaskStore

## Status

Accepted

## Context

Раньше в проекте были дублирующие сущности для задач: отдельный `TaskViewModel`, `TaskManager`, `CreateTaskView`, `NewTaskView`, `TaskRow` и `TaskRowView`. Из-за этого было непонятно, какой путь является основным, а тестировать логику было неудобно.

## Decision

Оставляем один основной поток:

- `TaskStore` хранит core-логику задач
- `TaskFileStore` отвечает за сохранение задач между запусками
- `TaskListQuery` хранит правила поиска, фильтрации и сортировки
- `TaskAnalytics` считает статистику по задачам
- `TaskManager` является ObservableObject-адаптером для SwiftUI
- `TaskListView`, `NewTaskView`, `TaskRowView` работают через `TaskManager`

Удалены старые дублирующие `TaskViewModel`, `CreateTaskView` и `TaskRow`.

## Consequences

Бизнес-логика задач теперь тестируется без SwiftUI, Combine и запуска приложения. UI остается тонким: он вызывает методы менеджера и отображает состояние.

Это улучшает SOLID/KISS: `TaskStore` отвечает за правила задач, `TaskManager` за связь с SwiftUI, экраны за отображение.
