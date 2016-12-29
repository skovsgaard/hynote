(import [flask [Flask render-template request]]
        [tinydb [TinyDB Query]])

(setv db (TinyDB "hynotes.json"))
(setv app (Flask "__main__"))

(with-decorator (app.route "/" :methods ["GET"])
  (defn get-index []
    (let [[data (db.all)]]
      (render-template "index.html" :notes data))))

(with-decorator (app.route "/<note_slug>" :methods ["GET"])
  (defn get-note [note-slug]
    (let [[q (Query)]
          [note-hash (first (db.search (= q.slug note-slug)))]]
      (if (!= note-hash nil)
        (render-template "show.html" :note note-hash)
        (render-template "404.html")))))

(with-decorator (app.route "/<note_slug>/edit" :methods ["GET"])
  (defn edit-Note [note-slug]
    (let [[q (Query)]
          [note-hash (first (db.search (= q.slug note-slug)))]]
      (if (!= note-hash nil)
        (render-template "edit.html" :note note-hash)
        (render-template "404.html")))))

(with-decorator (app.route "/<note_slug>/edit" :methods ["POST"])
  (defn do-edit-note [note-slug]
    (let [[q (Query)]
          [note-hash (first (db.search (= q.slug note-slug)))]
          [update-hash {"title" (get request.form "title")
                        "content" (get request.form "content")}]]
      (do (print request.form)
          (db.update update-hash (= q.slug note-slug))
          (.update note-hash update-hash)
          (render-template "show.html" :note note-hash)))))

