package com.s21.devops.sample.sessionservice.Service;

import io.micrometer.core.instrument.Counter;
import io.micrometer.core.instrument.MeterRegistry;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

@Component
public class MetricsCollector {

    private final Counter messagesSent;
    private final Counter messagesProcessed;
    private final Counter bookings;
    private final Counter requestsReceived;
    private final Counter authRequests;

    @Autowired
    public MetricsCollector(MeterRegistry registry) {
        this.messagesSent = registry.counter("rabbitmq.messages.sent");
        this.messagesProcessed = registry.counter("rabbitmq.messages.processed");
        this.bookings = registry.counter("bookings.total");
        this.requestsReceived = registry.counter("gateway.requests.received");
        this.authRequests = registry.counter("auth.requests.received");
    }

    public void incrementAuthRequest() {
        authRequests.increment();
    }

    public void incrementMessagesSent() {
        messagesSent.increment();
    }

    public void incrementBookings() {
        bookings.increment();
    }

    public void incrementMessagesProcessed() {
        messagesProcessed.increment();
    }

    public void incrementRequestReceived() {
        requestsReceived.increment();
    }
}

