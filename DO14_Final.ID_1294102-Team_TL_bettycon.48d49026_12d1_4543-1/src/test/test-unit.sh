#!/bin/sh
set -e
echo "=== Starting unit tests ==="

cd ../app/src || exit 1

for pkg in checkoutservice/money frontend/validator; do
    if [ -d "$pkg" ]; then
        echo "=== Testing $pkg ==="
        cd "$pkg" && go test -v && cd ../.. || exit 1
    fi
done

for service in productcatalogservice shippingservice; do
    if [ -f "$service/${service}_test.go" ]; then
        echo "=== Testing $service ==="
        cd "$service" && go test -v && cd .. || exit 1
    fi
done

echo "=== All tests passed ==="
