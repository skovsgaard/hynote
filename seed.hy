(import couchdb
        [slugify [slugify]])

(setv couch (couchdb.Server "http://localhost:5984/"))
(setv db (couch.create "hynote"))
(setv dummy-data [{"title" "Hy world"
                   "content" "Dear diary. Today I wrote an app in Hy."
                   "slug" (slugify "Hy world")}
                  {"title" "Oh by the way"
                   "content" "I never knew I needed a notetaking app"
                   "slug" (slugify "Oh by the way")}
                  {"title" "And one more thing"
                   "content" "Hy is the funnest language ever."
                   "slug" (slugify "And one more thing")}])

(for [row dummy-data] (db.save row))

(print "Seeded the CouchDB database")
