package com.s21.devops.sample.bookingservice.Service;
import io.micrometer.core.instrument.Counter;
import io.micrometer.core.instrument.MeterRegistry;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

@Component
public class MetricsCollectorRBMQ {

    private final Counter messagesSent;
    private final Counter messagesProcessed;
    private final Counter bookings;
    private final Counter requestsReceived;
    private final Counter authRequests;

    @Autowired
    public MetricsCollectorRBMQ(MeterRegistry registry) {
        this.messagesSent = registry.counter("rabbitmq.messages.sent");
        this.messagesProcessed = registry.counter("rabbitmq.messages.processed");
        this.bookings = registry.counter("bookings.total");
        this.requestsReceived = registry.counter("gateway.requests.received");
        this.authRequests = registry.counter("auth.requests.received");
    }

    // Methods to increment counters
    public void incrementMessagesSent() {
        messagesSent.increment();
    }

    public void incrementMessagesProcessed() {
        messagesProcessed.increment();
    }

    public void incrementBookings() {
        bookings.increment();
    }

    public void incrementRequestReceived() {
        requestsReceived.increment();
    }

    public void incrementAuthRequest() {
        authRequests.increment();
    }
}

