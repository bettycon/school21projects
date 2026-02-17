## Финальный проект DO14 — отчёт

### 1. Выбранный open-source проект

- **Название**: Online Boutique (microservices-demo)
- **Репозиторий**: https://github.com/GoogleCloudPlatform/microservices-demo
- **Критерии соответствия**:
  - более 3 микросервисов (frontend, cartservice, productcatalogservice, currencyservice, paymentservice и др.);
  - есть фронтенд (`src/frontend`);
  - использование отдельного хранилища данных (`redis-cart` для корзины).

### 2. Структура репозитория DO14

- `src/app` — код Online Boutique, склонированный из GitHub;
- `src/chart/online-boutique` — разработанный Helm-чарт;
- `.gitlab-ci.yml` — пайплайн с этапами build, test, staging, prod;
- `src/REPORT.MD` — данный отчёт.

### 3. Dockerfile и тесты

Здесь опиши:
- какие сервисы используются (frontend, cartservice, productcatalogservice, currencyservice, paymentservice);
- расположение их Dockerfile;
- какие модульные тесты запускаются (например, Go-тесты в `frontend` и `productcatalogservice`).

### 4. Helm-чарт

Опиши:
- какие ресурсы разворачиваются (Deployment/Service для frontend, cartservice, productcatalogservice, currencyservice, paymentservice, redis-cart);
- как настраиваются образы и теги через `values.yaml`;
- как устроен Ingress (хосты для staging/prod).

### 5. CI/CD пайплайн в GitLab

Опиши для `.gitlab-ci.yml`:
- **build** — сборка и пуш Docker-образов сервисов `frontend`, `cartservice`, `productcatalogservice`, `currencyservice`, `paymentservice` в Docker Hub с тегом `$CI_COMMIT_SHA` (автоматически для веток `feature_*`);
- **test** — запуск модульных тестов (Go-тесты для `frontend` и `productcatalogservice`);
- **staging** — ручной деплой Helm-чарта в namespace `staging-<tag>` с включённым Ingress;
- **prod** — ручной деплой Helm-чарта в namespace `prod`.

### 6. Скриншоты

Сюда вставь скриншоты:
- настройки кластера Kubernetes и GitLab Runner;
- успешной сборки и пуша образов;
- успешных стадий `build`, `test`, `staging`, `prod` в GitLab;
- вывода `kubectl get pods` и `kubectl get svc` в namespace staging/prod;
- работы фронтенда в браузере.

