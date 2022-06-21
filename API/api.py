import flask
import io
import os.path
import werkzeug.wsgi

app = flask.Flask(__name__)

@app.route("/")
def index():
    return """
<p>🇷🇺 API для примеров приложений iOS для архитектурного шаблона \"Мрак в Моделях\" (MM)</p>
<p>🇬🇧 API for iOS application examples of \"Murk in Models\" (MM) architecture pattern</p>
"""

@app.route("/systemInfo")
def system_info():
    return """
{
    "apiVersion": "2.0.0",
    "domain": {
        "name": "Тысячелѣтіе Россіи",
        "logoResourceId": "72F590A0-27EC-4A9F-B1BF-A1F898880F82"
    }
}
"""

@app.route("/resource/<string:id>")
def resource(id):
    # https://www.pythonanywhere.com/forums/topic/13570/
    filename = "static/{0}.jpg".format(id)
    with open(filename, "rb") as f:
        b = io.BytesIO(f.read())
        w = werkzeug.wsgi.FileWrapper(b)
        return flask.Response(w, mimetype = "image/jpg", direct_passthrough = True)
    return flask.abort(404)
