#!/bin/bash
pactl unload-module module-combine-sink
pactl load-module module-combine-sink
