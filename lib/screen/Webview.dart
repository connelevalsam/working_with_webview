import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:ranqz/screen/Authors.dart';
import 'package:webview_flutter/webview_flutter.dart';

class Webview extends StatefulWidget {
  @override
  _WebviewState createState() => _WebviewState();
}

class _WebviewState extends State<Webview> {
  final Completer<WebViewController> _controller =
  Completer<WebViewController>();
  WebViewController _con;

  /*
  *
  * Webview
  * */

  String setHTML(String email, String phone, String name) {
    // ref = generateUuid();
    return ('''
    <html>
      <head>
        <!-- Required meta tags -->
        <meta charset="utf-8">
        <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
        <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/4.0.0/css/bootstrap.min.css" integrity="sha384-Gn5384xqQ1aoWXA+058RXPxPg6fy4IWvTNh0E263XmFcJlSAwiGgFAW/dAiS6JXm" crossorigin="anonymous">
        <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.5.1/jquery.min.js"></script>
        <script src="https://maxcdn.bootstrapcdn.com/bootstrap/3.4.1/js/bootstrap.min.js"></script>
      </head>
      
      <style>
        ul {
          list-style: none; 
          background: #0f2027; /* fallback for old browsers */
          background: -webkit-linear-gradient(to right, #0f2027, #203a43, #2c5364); /* Chrome 10-25, Safari 5.1-6 */
          background: linear-gradient(to right, #0f2027, #203a43, #2c5364); /* W3C, IE 10+/ Edge, Firefox 16+, Chrome 26+, Opera 12+, Safari 7+ */
        }
        li {margin-bottom: 3.5em;}
        li span{color: white;}
      </style>
      
        <body style="background-color:#fff;height:100vh ">

          <div style="width: 50%; margin: 0 auto;margin-top: 200px">
            <table class="table table-striped">
              <tbody>
                <tr>
                  <th>Name</th>
                  <th>$name</th>
                </tr>
                <tr>
                  <th>Email</th>
                  <td>$email</td>
                </tr>
                <tr>
                  <th>Phone</th>
                  <th>$phone</th>
                </tr>
              </tbody>
            </table>
            <button type="button" class="btn btn-info" onclick="getAuthors()" style="width: 210px">
              Authors
            </button>
            <br /> <br />
            <a type="button" class="btn btn-success" style="width: 210px" href="https://connelevalsam.github.io/connelblaze/">
              Submit
            </a>
            <h2>This is my JS</h2>
            <div>
              <h1>Authors</h1>
              <ul id="authors"></ul>
            </div>
          </div>
          <script>
            const header = document.querySelector('h2');
            const ul = document.querySelector('#authors');
            const url = 'https://randomuser.me/api/?results=10';
            function hello() {
            header.innerText = 'my new Header';
            Toaster.postMessage("Hello from the other side");
            }
            function createNode(element) {
                return document.createElement(element);
            }
            
            function append(parent, el) {
              return parent.appendChild(el);
            }
            
            function getAuthors() {
              let i = 2;
              fetch(url)
              .then((res) => res.json())
              .then(function(data) {
                let authors = data.results;
                
                return authors.map(function(author) {
                let arr = [];
                arr[0] = author.name.first;
                arr[1] = author.name.last;
                arr[2] = author.picture.medium;
                Toaster.postMessage(arr[0]);
                Toaster.postMessage(arr[1]);
                Toaster.postMessage(arr[2]);
                  let li = createNode('li');
                  let img = createNode('img');
                  let span = createNode('span');
                  img.src = author.picture.medium;
                  span.innerHTML = author.name.first +" "+ author.name.last;
                  append(li, img);
                  append(li, span);
                  append(ul, li);
                  ul.style.padding = '1em';
                })
              })
              .catch(function(error) {
                console.log(error);
              });
            }
          </script>
        </body>
      </html>
      

    ''');
  }

  List details = [];
  bool isDone = false;
  JavascriptChannel _toasterJavascriptChannel(BuildContext context) {
    return JavascriptChannel(
        name: 'Toaster',
        onMessageReceived: (JavascriptMessage message) {
          // ignore: deprecated_member_use
          details.add(message.message);
          print(details);
          setState(() {
            isDone = true;
          });
          if (isDone == true) {
            showAlertDialog(context, "Proceed", type: true);

            setState(() {
              isDone = false;
            });
          }
        });
  }

  void showAlertDialog(BuildContext context, String msg, {bool type = false}) {
    // set up the button
    Widget okButton = TextButton(
      child: Container(
        color: Colors.green,
          padding: EdgeInsets.all(10.0),
          child: Text("Continue", style: TextStyle(color: Colors.white),)
      ),
      onPressed: () {
        Navigator.of(context, rootNavigator: true).pop();
        Future.delayed(const Duration(milliseconds: 500), () {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => Authors(res: details,)));
        });
      },
    );

    Widget noButton = TextButton(
      child: Container(
          color: Colors.red,
          padding: EdgeInsets.all(10.0),
          child: Text("Cancel", style: TextStyle(color: Colors.white),)
      ),
      onPressed: () {
        Navigator.of(context, rootNavigator: true).pop();
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text((
          type == true ? "Message" : "Error"
      )),
      content: Text(msg),
      actions: [
        noButton,
        okButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  _loadHTML() async {
    _con.loadUrl(Uri.dataFromString(
        setHTML(
          "connelblaze@gmil.com",
          "+2347034857296",
          "Connel Asikong"
        ),
        mimeType: 'text/html',
        encoding: Encoding.getByName('utf-8')
    ).toString());
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Webview'),
      ),
      body: Builder(builder: (BuildContext context) {
        return WebView(
          initialUrl: 'https://flutter.dev',
          javascriptMode: JavascriptMode.unrestricted,
          onWebViewCreated: (WebViewController webViewController) {
            // _controller.complete(webViewController);
            _con = webViewController;
            _loadHTML();
          },
          onProgress: (int progress) {
            print("WebView is loading (progress : $progress%)");
          },
          javascriptChannels: <JavascriptChannel>{
            _toasterJavascriptChannel(context),
          },
          onPageStarted: (String url) {
            print('Page started loading: $url');
          },
          onPageFinished: (String url) {
            print('Page finished loading: $url');
          },
          gestureNavigationEnabled: true,
        );
      }),
    );
  }

}


