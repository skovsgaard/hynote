(import [tinydb [TinyDB]]
        [slugify [slugify]])

(setv db (TinyDB "hynotes.json"))
(setv dummy-data [{"id" 0
                   "title" "Hy world"
                   "content" "Dear diary. Today I wrote an app in Hy."
                   "slug" (slugify "Hy world")}
                  {"id" 1
                   "title" "Oh by the way"
                   "content" "I never knew I needed a notetaking app"
                   "slug" (slugify "oh by the way")}
                  {"id" 2
                   "title" "And one more thing"
                   "content" "Hy is the funnest language ever."
                   "slug" (slugify "and one more thing")}])

(for [row dummy-data]
  (db.insert row))

(print "Seeded the TinyDB datastore")
