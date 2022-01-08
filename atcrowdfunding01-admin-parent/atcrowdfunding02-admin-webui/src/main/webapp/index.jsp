<%@ page language="java" contentType="text/html; charset=utf-8"
         pageEncoding="utf-8" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset=utf-8">
    <title>首页</title>

    <base href="http://${pageContext.request.serverName}:${pageContext.request.serverPort}${pageContext.request.contextPath}/" />
    <script type="text/javascript" src="jquery/jquery-2.1.1.min.js"></script>
    <script type="text/javascript" src="layer/layer.js"></script>
    <script>
      $(function() {

        $("#btn3").click(function () {
          layer.msg("Layer弹窗")
        });

        let array = [5, 8, 12];
        let arrayStr = JSON.stringify(array);
        $("#btn2").click(function () {
          $.ajax({
            url: "send/array/two.html", // 请求目标资源的地址
            type: "post", // 请求方式
            data: arrayStr, // 要发送的请求参数
            contentType: "application/json;charset=UTF-8", // 告诉服务器当前请求的请求体是 JSON 格式
            dataType: "text", // 如何对待服务器返回的数据
            success: function (response) { // 服务器段处理请求成功后调用的回调函数，response 是相应体数据
              alert(response);
            },
            error: function (response) {// 服务器段处理请求失败后调用的回调函数
              alert(response);
            }
          })
        });

        $("#btn1").click(function () {
          $.ajax({
            url: "send/array/one.html", // 请求目标资源的地址
            type: "post", // 请求方式
            data: {
              array: [5, 8, 12]
            }, // 要发送的请求参数
            dataType: "text", // 如何对待服务器返回的数据
            success: function (response) { // 服务器段处理请求成功后调用的回调函数，response 是相应体数据
              alert(response);
            },
            error: function (response) {// 服务器段处理请求失败后调用的回调函数
              alert(response);
            }
          })
        })
      });
    </script>
</head>
<body>
    <a href="test/ssm.html">测试 SSM 整合环境</a>

    <br/>
    <br/>

    <button id="btn1">Send [5, 8, 12] One</button>

    <br/>
    <br/>

    <button id="btn2">Send [5, 8, 12] Two</button>

    <br/>
    <br/>

    <button id="btn3">点我弹窗</button>
</body>
</html>