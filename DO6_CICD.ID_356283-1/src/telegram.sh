#!/bin/bash

# Конфигурация бота Telegram
BOT_TOKEN="7839750070:AAGEedgCiOW4iXErvhF75SONDy7WcIKEK_E"
CHAT_ID="-4884397886"

sleep 2

# Автоматическое определение типа стадии по имени job
case "$CI_JOB_NAME" in
    "build_app")
        STAGE_TYPE="Сборка (Build)"
        ;;
    "check_style")
        STAGE_TYPE="Проверка кодстайла (Style)"
        ;;
    "integration_tests")
        STAGE_TYPE="Интеграционные тесты (Test)"
        ;;
    "deploy_to_server")
        STAGE_TYPE="Деплой (Deploy)"
        ;;
    *)
        STAGE_TYPE="$CI_JOB_NAME"
        ;;
esac

PIPELINE_URL="https://git.21-school.ru/students_repo/bettycon/DO6_CICD.ID_356283-1/-/pipelines"

if [[ "$CI_JOB_STATUS" == "success" ]]; then
    MESSAGE="✅ Bettycon DO6 CI/CD ✅

🎯 Стадия: $STAGE_TYPE
📦 Проект: ${CI_PROJECT_NAME:-DO6 CICD}
🌿 Ветка: ${CI_COMMIT_REF_NAME:-main}
✅ Статус: Успешно завершено

🔗 Пайплайн: $PIPELINE_URL"
else
    MESSAGE="🚫 Bettycon DO6 CI/CD 🚫

🎯 Стадия: $STAGE_TYPE
📦 Проект: ${CI_PROJECT_NAME:-DO6 CICD}
🌿 Ветка: ${CI_COMMIT_REF_NAME:-main}
❌ Статус: Завершено с ошибкой

🔗 Пайплайн: $PIPELINE_URL"
fi

curl -s -X POST "https://api.telegram.org/bot$BOT_TOKEN/sendMessage" \
    -d chat_id="$CHAT_ID" \
    -d text="$MESSAGE"

echo "Telegram notification sent for $STAGE_TYPE: $CI_JOB_STATUS"
