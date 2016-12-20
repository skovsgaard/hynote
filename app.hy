(require hy.contrib.meth)
(import [flask [Flask render-template]]
        [tinydb [TinyDB Query]])

(setv db (TinyDB "hynotes.json"))

(setv app (Flask "__main__"))

(route get-index "/" []
       (let [[data (db.all)]]
         (render-template "index.html" :notes data)))

(route get-note "/<note_slug>" [note-slug]
       (let [[q (Query)]
             [note-hash (first (db.search (= q.slug note-slug)))]]
         (if (!= note-hash nil)
           (render-template "show.html" :note note-hash)
           (render-template "404.html"))))

(route edit-note "/<note>/edit" []
       (let [[q (Query)]
             [note-hash (db.search (= q.id (int note)))]]
         (render-template "edit.html" :note note-hash)))
