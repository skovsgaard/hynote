(import [flask [Flask render-template request]]
        couchdb
        [slugify [slugify]])

(setv couch (couchdb.Server))
(setv db (get couch "hynote"))
(setv app (Flask "__main__"))

(with-decorator (app.route "/" :methods ["GET"])
  (defn get-index []
    (let [[data-view (db.view "notes/by_slug")]
          [data (map (fn [x] x.value) data-view.rows)]]
      (render-template "index.html" :notes data))))

(with-decorator (app.route "/<note_slug>" :methods ["GET"])
  (defn get-note [note-slug]
    (let [[note-hash (find-by-slug note-slug db)]]
      (if (!= note-hash nil)
        (render-template "show.html" :note note-hash)
        (render-template "404.html")))))

(with-decorator (app.route "/<note_slug>/edit" :methods ["GET"])
  (defn edit-Note [note-slug]
    (let [[note-hash (find-by-slug note-slug db)]]
      (if (!= note-hash nil)
        (render-template "edit.html" :note note-hash)
        (render-template "404.html")))))

(with-decorator (app.route "/<note_slug>/edit" :methods ["POST"])
  (defn do-edit-note [note-slug]
    (let [[note-hash (find-by-slug note-slug db)]
          [title (get request.form "title")]
          [update-hash {"title" title
                        "content" (get request.form "content")
                        "slug" (slugify title)
                        "_rev" (get note-hash "_rev")}]]
      (do (setv (get db (get note-hash "_id")) update-hash)
          (render-template "show.html" :note update-hash)))))

(defn find-by-slug [slug database]
  (let [[data-view (database.view "notes/by_slug")]]
    (get (first (filter (fn [x]
                          (= (get x.value "slug") slug))
                        data-view))
         "value")))
