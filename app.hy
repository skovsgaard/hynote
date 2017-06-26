(import [flask [Flask render-template redirect request]]
        [tinydb [TinyDB Query]])

(setv db (TinyDB "hynotes.json"))
(setv app (Flask "__main__"))

#@((app.route "/" :methods ["GET"])
   (defn get-index []
     (setv data (db.all))
     (render-template "index.html" :notes data)))

#@((app.route "/new" :methods ["GET"])
   (defn new-note []
     (render-template "new.html")))

#@((app.route "/create" :methods ["POST"])
   (defn create-note []
     (print request.form)
     (redirect "/")))

#@((app.route "/<note_slug>" :methods ["GET"])
   (defn get-note [note-slug]
     (setv q (Query))
     (setv note-hash (first (db.search (= q.slug note-slug))))
     (if note-hash
       (render-template "show.html" :note note-hash)
       (render-template "404.html"))))

#@((app.route "/<note_slug>/edit" :methods ["GET"])
   (defn edit-Note [note-slug]
     (setv q (Query))
     (setv note-hash (first (db.search (= q.slug note-slug))))
     (if note-hash
       (render-template "edit.html" :note note-hash)
       (render-template "404.html"))))

#@((app.route "/<note_slug>/edit" :methods ["POST"])
   (defn do-edit-note [note-slug]
     (setv q (Query))
     (setv note-hash (first (db.search (= q.slug note-slug))))
     (setv update-hash {"title" (get request.form "title")
                        "content" (get request.form "content")})
     (do (print request.form)
         (db.update update-hash (= q.slug note-slug))
         (.update note-hash update-hash)
         (render-template "show.html" :note note-hash))))

