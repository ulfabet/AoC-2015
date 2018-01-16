#!/bin/sh

grep '\(\w\).\1' - | grep '\(\w\w\).*\1' | wc 
