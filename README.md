# HyNote

This is a sample application showing how to build a simple web application using the Hy language with the Flask framework (without using the built-in `contrib.meth` module).

It uses TinyDB which stores its "database" as a regular JSON file. Given that TinyDB is essentially document oriented, this sample app should be possible to adapt for use with Couch, Mongo, or similar.

If you want information on how to use CouchDB with Flask and Hy in the same way, please see the `couch` branch of this repository.

## Running the app

Flask needs a real Python entrypoint, so I've created `boot.py`. Before starting the app, you might want a dummy database, so run `hy seed.hy` first, then run `python boot.py`. You're now up and running.

## Requirements

This app is intended for a virtual environment in which you have Hy, TinyDB, slugify, and Flask installed. If you have that or the modules installed globally for some reason, you're good to go.

### License
Unlicense. See LICENSE for full text.
