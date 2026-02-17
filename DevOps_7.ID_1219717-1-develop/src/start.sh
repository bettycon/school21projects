#!/bin/bash
echo "Starting manager01..."
vagrant up manager01

echo "Waiting 30 seconds before starting worker01..."
sleep 30

echo "Starting worker01..."
vagrant up worker01

echo "Waiting 30 seconds before starting worker02..."
sleep 30

echo "Starting worker02..."
vagrant up worker02

echo "All nodes started!"
