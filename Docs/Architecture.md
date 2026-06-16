# Architecture Overview

Проект разделен по фичам и слоям, чтобы UI не держал основную бизнес-логику.

В проекте есть физический framework target `HWmobileCore`. В него вынесены модели, DTO-маппинг и чистая бизнес-логика, которые не зависят от SwiftUI. App target `HWmobile` содержит экраны, view model/state adapters и работу с платформенными сервисами.

## App

`HWmobileApp` создает общий `TaskManager` и передает его в `MainTabView` через `EnvironmentObject`.
`MainTabView` отвечает только за вкладки приложения:

- `NewsListView`
- `NoteListView`
- `TaskListView`

## Tasks

Фича задач разделена на:

- core module `HWmobileCore`: `Task`, `TaskDraft`, `TaskPriority`, `TaskValidationError`, `TaskStore`, `TaskFileStore`, `TaskListQuery`, `TaskFilter`, `TaskSortOption`, `TaskAnalytics`
- SwiftUI-адаптер состояния: `TaskManager`
- экраны и компоненты: `TaskListView`, `NewTaskView`, `TaskRowView`

Основная логика создания, удаления и обновления задач находится в `TaskStore`. Это обычный value type без SwiftUI и Combine, поэтому его легко тестировать.
`TaskFileStore` сохраняет задачи в JSON в Application Support, поэтому задачи не пропадают после перезапуска приложения.
Логика поиска, фильтров, сортировки и статистики также вынесена из `TaskListView`, чтобы экран занимался отображением и пользовательским вводом.

## News

Фича новостей разделена на:

- UI: `NewsListView`
- состояние экрана: `NewsViewModel`
- источник данных: `NewsRepository`
- сеть: `NYTimesNewsService`
- кэш статей: `CachedNewsStore`
- кэш картинок: `NewsImageCacheStore`
- core module `HWmobileCore`: `NewsArticleDisplay`, `NewsDataSource`, `NewsDTOMapper`, `NewsDemoData`, `NewsCachePolicy`

`NewsViewModel` не разбирает JSON и не работает напрямую с файловой системой. Эти ответственности вынесены ниже по слоям.
Если `NYTIMES_API_KEY` не задан и кэша нет, экран показывает демо-новости вместо ошибки.

## Notes

Фича заметок разделена на:

- core module `HWmobileCore`: `Note`, `NoteDraft`, `NoteValidationError`, `NoteStore`, `NoteListQuery`, `NoteFileStore`
- SwiftUI-адаптер состояния: `NoteManager`
- экраны и компоненты: `NoteListView`, `NoteEditorView`

`NoteStore` отвечает за создание, редактирование и удаление заметок. `NoteListQuery` отвечает за поиск и сортировку по дате обновления. `NoteFileStore` сохраняет заметки в JSON в Application Support.

## Tests

Unit-тесты лежат в `HWmobileTests`:

- `TaskStoreTests` покрывает core-логику задач
- `TaskFileStoreTests` покрывает сохранение и восстановление задач
- `TaskListQueryTests` покрывает поиск, фильтры и сортировку
- `TaskAnalyticsTests` покрывает статистику задач
- `NoteStoreTests` покрывает создание, валидацию и редактирование заметок
- `NoteListQueryTests` покрывает поиск и сортировку заметок
- `NoteFileStoreTests` покрывает сохранение и восстановление заметок
- `NewsDTOMapperTests` покрывает маппинг ответа NY Times
- `CachedNewsStoreTests` покрывает сохранение и чтение кэша

UI-тесты лежат в `HWmobileUITests`:

- `testCreateTaskHappyPath` проверяет пользовательский сценарий создания задачи
- `testCreateNoteHappyPath` проверяет пользовательский сценарий создания заметки
- `testTasksScreenSnapshot` делает snapshot-скриншот экрана задач и прикладывает его к результатам тестов

Тесты запускаются через shared scheme `HWmobile`.
