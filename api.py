import flask
import os.path

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
    filename = "static/{0}.jpg".format(id)
    if os.path.isfile(filename):
      return flask.send_file(filename, mimetype="image/jpg")
    return flask.abort(404)
