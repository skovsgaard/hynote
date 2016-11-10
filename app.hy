(require hy.contrib.meth)
(import [flask [Flask render_template]]
        [tinydb [TinyDB Query]])

(setv db (TinyDB "super-great-db.json"))

(setv app (Flask "__main__"))

(route get-index "/" [] (render-template "index.html"))
