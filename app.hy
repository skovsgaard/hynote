(import [flask [Flask render-template redirect request]]
        couchdb
        [slugify [slugify]])

(setv couch (couchdb.Server))
(setv db (get couch "hynote"))
(setv app (Flask "__main__"))

#@((app.route "/" :methods ["GET"])
  (defn get-index []
    (let [data-view (db.view "notes/by_slug")
          data (map (fn [x] x.value) data-view.rows)]
      (render-template "index.html" :notes data))))

#@((app.route "/<note_slug>" :methods ["GET"])
  (defn get-note [note-slug]
    (let [note-hash (find-by-slug note-slug db)]
      (if (!= note-hash nil)
        (render-template "show.html" :note note-hash)
        (render-template "404.html")))))

#@((app.route "/<note_slug>/edit" :methods ["GET"])
  (defn edit-Note [note-slug]
    (let [note-hash (find-by-slug note-slug db)]
      (if (!= note-hash nil)
        (render-template "edit.html" :note note-hash)
        (render-template "404.html")))))

#@((app.route "/<note_slug>/edit" :methods ["POST"])
  (defn do-edit-note [note-slug]
    (let [note-hash (find-by-slug note-slug db)
          title (get request.form "title")
          update-hash {"title" title
                       "content" (get request.form "content")
                       "slug" (slugify title)
                       "_rev" (get note-hash "_rev")}]
      (do (setv (get db (get note-hash "_id")) update-hash)
          (render-template "show.html" :note update-hash)))))

#@((app.route "/<note_slug>/delete" :methods ["POST"])
  (defn delete-note [note-slug]
    (let [to-delete (find-by-slug note-slug db)]
      (->> (get to-delete "_id")
           (get db)
           del)
      (redirect "/"))))

#@((app.route "/new" :methods ["GET"])
  (defn new-note []
    (render-template "new.html")))

#@((app.route "/create" :methods ["POST"])
  (defn create-note []
    (let [create-hash {"title" (get request.form "title")
                                 "content" (get request.form "content")
                                 "slug" (slugify (get request.form "title"))}]
      (db.save create-hash)
      (redirect (+ "/" (get create-hash "slug"))))))

(defn find-by-slug [slug database]
  (let [data-view (database.view "notes/by_slug")]
    (get (first (filter (fn [x] (= (get x.value "slug") slug))
                        data-view))
         "value")))
