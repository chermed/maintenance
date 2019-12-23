from flask import Flask, escape, request
import os
from jinja2 import Template


app = Flask(__name__)

template = """
<!doctype html>
<head>
    <title>{{TITLE}}</title>
    <meta charset="UTF-8">
    <style>
        body { text-align: center; padding: 150px; }
        h1 { font-size: 50px; }
        body { font: 20px Helvetica, sans-serif; color: #333; }
        article { display: block; text-align: left; width: 650px; margin: 0 auto; }
        a { color: #dc8100; text-decoration: none; }
        a:hover { color: #333; text-decoration: none; }
    </style>

</head>
<body>
    <article>
        <h1>{{HEADER}}</h1>
        <div>
            <p>{{BODY}}</p>
            <p>— {{TEAM}}</p>
        </div>
    </article>
</body>
"""
@app.route('/')
def hello():
    return Template(template).render(**os.environ)
