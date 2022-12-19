import os
from flask import Flask
from flask import Flask, render_template

#initialize app
app = Flask(__name__)

@app.route('/', methods = ["GET"])
def dicom_viewer():
    """
    Returns viewer
    """
    title = 'Dicom Viewer'
    return render_template('index.html', title = title)

if __name__ == "__main__":
    app.run(debug = True, host = '0.0.0.0', port = int(os.environ.get('PORT', 8080)))

