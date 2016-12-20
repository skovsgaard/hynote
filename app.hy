(require hy.contrib.meth)
(import [flask [Flask render-template]]
        [tinydb [TinyDB Query]])

(setv db (TinyDB "hynotes.json"))

(setv app (Flask "__main__"))

(route get-index "/" []
       (let [[data (db.all)]]
         (render-template "index.html" :notes data)))

(route get-note "/<note>" []
       (let [[q (Query)]
             [note-hash (db.search (= q.id (int note)))]]
         (render-template "index.html" :note note-hash)))
