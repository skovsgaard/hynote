(import [tinydb [TinyDB Query]])

(setv db (TinyDB "hynotes.json"))
(setv dummy-data [{"id" 0
                   "title" "Hy world"
                   "content" "Dear diary. Today I wrote an app in Hy."}
                  {"id" 1
                   "title" "Oh by the way"
                   "content" "I never knew I needed a notetaking app"}
                  {"id" 2
                   "title" "And one more thing"
                   "content" "Hy is the funnest language ever."}])

(for [row dummy-data]
  (db.insert row))
