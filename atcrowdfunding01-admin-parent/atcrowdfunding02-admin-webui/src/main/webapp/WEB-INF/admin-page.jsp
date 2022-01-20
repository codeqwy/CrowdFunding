<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" pageEncoding="utf-8" %>
<!DOCTYPE html>
<html lang="GB18030">
<%@include file="/WEB-INF/include-head.jsp" %>
<link rel="stylesheet" href="static/css/pagination.css"/>
<script type="text/javascript" src="static/jquery/jquery.pagination.js"></script>
<script type="text/javascript">
  $(function () {
    initPagination();
  });

  function initPagination() {
    // 获取总记录数
    let totalRecord = ${pageInfo.total};
    // 生成页码导航条
    $("#Pagination").pagination(totalRecord, {
      num_edge_entries: 1, // 边缘页数
      num_display_entries: 5, // 主体页数
      callback: pageSelectCallback, // 指定用户点击”翻页“的按钮时跳转页面的回调函数
      items_per_page: ${pageInfo.pageSize}, // 每页要显示的数据的数量
      current_page: ${pageInfo.pageNum - 1}, // 当前页数下标
      prev_text: "上一页",
      next_text: "下一页"
    });
  }

  function pageSelectCallback(pageIndex, jQuery) {
    let pageNum = pageIndex + 1;
    window.location.href = "admin/get/page.html?pageNum=" + pageNum + "&keyword=${param.keyword}";
    return false;
  }

  function delMessage() {
    $("#delBtn").click({})
  }
</script>
<body>
<%@include file="/WEB-INF/include-nav.jsp" %>
<div class="container-fluid">
  <div class="row">
    <%@include file="/WEB-INF/include-sidebar.jsp" %>
    <div class="col-sm-9 col-sm-offset-3 col-md-10 col-md-offset-2 main">
      <div class="panel panel-default">
        <div class="panel-heading">
          <h3 class="panel-title">
            <i class="glyphicon glyphicon-th"></i> 数据列表
          </h3>
        </div>
        <div class="panel-body">
          <form action="admin/get/page.html" method="post" class="form-inline" role="form" style="float: left;">
            <div class="form-group has-feedback">
              <div class="input-group">
                <div class="input-group-addon">查询条件</div>
                <input name="keyword" class="form-control has-success" type="text"
                       placeholder="请输入查询条件" value="${param.keyword}">
              </div>
            </div>
            <button type="submit" class="btn btn-warning">
              <i class="glyphicon glyphicon-search"></i> 查询
            </button>
          </form>
          <button type="button" class="btn btn-danger"
                  style="float: right; margin-left: 10px;">
            <i class=" glyphicon glyphicon-remove"></i> 删除
          </button>
          <%--<button type="button" class="btn btn-primary"
                  style="float: right;" onclick="window.location.href='add.html'">

          </button>--%>
          <a href="admin/to/add/page.html" style="float: right;" class="btn btn-primary"><i
                class="glyphicon glyphicon-plus"></i> 新增</a>
          <br>
          <hr style="clear: both;">
          <div class="table-responsive">
            <table class="table  table-bordered">
              <thead>
              <tr>
                <th width="30">#</th>
                <th width="30"><input type="checkbox"></th>
                <th>账号</th>
                <th>名称</th>
                <th>邮箱地址</th>
                <th width="100">操作</th>
              </tr>
              </thead>
              <tbody>
              <c:if test="${empty requestScope.pageInfo.list}">
                <tr>
                  <td colspan="6" align="center">抱歉！没有查询到您要的数据！</td>
                </tr>
              </c:if>
              <c:if test="${!empty requestScope.pageInfo.list}">
                <c:forEach items="${requestScope.pageInfo.list}" var="admin" varStatus="myStatus">
                  <tr>
                    <td>${myStatus.count}</td>
                    <td><input type="checkbox"></td>
                    <td>${admin.loginAcct}</td>
                    <td>${admin.userName}</td>
                    <td>${admin.email}</td>
                    <td>
                        <%--<button type="button" class="btn btn-success btn-xs">
                            <i class=" glyphicon glyphicon-check"></i>
                        </button>
                        <button type="button" class="btn btn-primary btn-xs">
                            <i class=" glyphicon glyphicon-pencil"></i>
                        </button>--%>
                      <a href="assign/to/assign/role/page.html?adminId=${admin.id }&pageNum=${pageInfo.pageNum }&keyword=${param.keyword }"
                         class="btn btn-success btn-xs"><i class=" glyphicon glyphicon-check"></i></a>
                      <a href="admin/to/edit/page.html?adminId=${admin.id}" class="btn btn-primary btn-xs"><i
                            class=" glyphicon glyphicon-pencil"></i></a>
                      <a href="admin/remove/${admin.id}.html" id="delBtn" class="btn btn-danger btn-xs"><i
                            class=" glyphicon glyphicon-remove"></i></a>
                    </td>
                  </tr>
                </c:forEach>
              </c:if>
              </tbody>
              <tfoot>
              <tr>
                <td colspan="6" align="center">
                  <%--<ul class="pagination">
                      <li class="disabled"><a href="#">上一页</a></li>
                      <li class="active"><a href="#">1 <span
                              class="sr-only">(current)</span></a></li>
                      <li><a href="#">2</a></li>
                      <li><a href="#">3</a></li>
                      <li><a href="#">4</a></li>
                      <li><a href="#">5</a></li>
                      <li><a href="#">下一页</a></li>
                  </ul>--%>
                  <div id="Pagination" class="pagination"><!-- 这里显示分页 --></div>
                </td>
              </tr>
              </tfoot>
            </table>
          </div>
        </div>
      </div>
    </div>
  </div>
</div>

</body>
</html>
