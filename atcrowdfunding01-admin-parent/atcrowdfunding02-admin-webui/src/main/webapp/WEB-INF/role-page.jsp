<%@ page contentType="text/html;charset=UTF-8" language="java" pageEncoding="utf-8" %>
<!DOCTYPE html>
<html lang="zh-CN">
<%@include file="/WEB-INF/include-head.jsp" %>
<link rel="stylesheet" href="static/css/pagination.css"/>
<link rel="stylesheet" href="static/ztree/zTreeStyle.css">
<script type="text/javascript" src="static/jquery/jquery.pagination.js"></script>
<script src="static/ztree/jquery.ztree.all-3.5.min.js"></script>
<script type="text/javascript" src="static/js/my-role.js" charset="UTF-8"></script>
<script type="text/javascript">
  $(function () {
    // 1.为分页初始化数据
    window.pageNum = 1;
    window.pageSize = 5;
    window.keyword = "";
    // 2.调用执行分页的函数，显示分页效果
    generatePage();

    // 给查询按钮绑定单击响应函数
    $("#searchBtn").click(function () {
      // 设置全局变量的 keyword 为 id=inputKeyword 的元素中的内容
      window.keyword = $("#inputKeyword").val();
      // 将页码归为 1
      window.pageNum = 1;
      // 重新执行分页操作
      generatePage();
    });

    // 单击添加按钮，打开添加角色的模态框
    $("#showAddModalBtn").click(function () {
      $("#addRoleModal").modal("show");
    });

    // 单击模态框中的保存按钮，给后端发送要保存的数据
    $("#saveRoleBtn").click(function () {
      // 获取id为addRoleModal的子元素中name为"roleName"的元素的内容，并去空格(trim)
      let roleName = $.trim($("#addRoleModal [name=roleName]").val());
      $.ajax({
        url: "role/do/save.json",
        type: "post",
        data: {
          name: roleName
        },
        dataType: "json",
        success: function (response) {
          // 返回的result为SUCCESS
          if (response.result == "SUCCESS") {
            layer.msg("操作成功！");

            window.pageNum = 9999;
            generatePage();
          }
          // 返回的result为FAILED
          if (response.result == "FAILED")
            layer.msg("操作失败" + response.message)
        },
        error: function (response) {
          layer.msg("失败！响应状态码：" + response.status + "，说明信息：" + response.statusText);
        }
      });
      // 关闭模态框
      $("#addRoleModal").modal("hide");
      // 清理模态框
      $("#addRoleModal [name=roleName]").val("");
    });

    // 给铅笔按钮绑定单击响应函数
    // 注意，如果这里使用简单的$(".pencilBtn").click();来绑定，会发现只在初始页生效，当进入其他页码时，按钮失效
    // 因此，这里使用jQuery的on()函数解决上面的问题
    // on()函数三个传参：1、事件名 ; 2、真正要绑定的按钮的选择器 ; 3、绑定的函数
    $("#rolePageBody").on("click", ".pencilBtn", function () {
      // 打开模态框
      $("#editRoleModal").modal("show");
      // 获取表格中当前行的roleName（通过找父元素的前一个兄弟元素）
      let roleName = $(this).parent().prev().text();
      // 根据pencilBtn的id获得角色id
      // 存放在全局变量中，为了让执行更新操作的按钮可以获取到roleId
      window.roleId = this.id;
      // 将得到的roleName填充到模态框中
      $("#editRoleModal [name=roleName]").val(roleName);
    });

    // 给更新模态框中的更新按钮绑定单击响应函数
    $("#updateRoleBtn").click(function () {

      // 从模态框的文本框中获得修改后的roleName
      let roleName = $("#editRoleModal [name=roleName]").val();

      $.ajax({
        url: "role/do/update.json",
        type: "post",
        data: {
          "id": window.roleId,
          "name": roleName
        },
        dataType: "json",
        success: function (response) {
          if (response.result == "SUCCESS") {
            layer.msg("操作成功！");
            generatePage();
          }
          if (response.result == "FAILED")
            layer.msg("操作失败" + response.message)
        },
        error: function (response) {
          layer.msg("失败！响应状态码：" + response.status + "，说明信息：" + response.statusText);
        }
      });
      // 关闭模态框
      $("#editRoleModal").modal("hide");
    });

    // 为 “确认删除” 按钮绑定单击事件
    $("#confirmRoleBtn").click(function () {
      let arrayStr = JSON.stringify(window.roleIdArray);
      $.ajax({
        url: "role/do/remove.json",
        type: "post",
        data: arrayStr,
        dataType: "json",
        contentType: "application/json;charset=UTF-8",
        success: function (response) {
          if (response.result == "SUCCESS") {
            layer.msg("操作成功！");
            $("#summaryBox").prop("checked", false);
            generatePage();
          }
          if (response.result == "FAILED")
            layer.msg("操作失败" + response.message)
        },
        error: function (response) {
          layer.msg("失败！响应状态码：" + response.status + "，说明信息：" + response.statusText);
        }
      });
      // 关闭模态框
      $("#confirmRoleModal").modal("hide");
    });

    // 给单条删除按钮绑定单击事件
    $("#rolePageBody").on("click", ".removeBtn", function () {
      let roleArray = [{
        "id": this.id,
        "name": $(this).parent().prev().text()
      }]
      showConfirmModal(roleArray);
    });

    // 给多选删除按钮绑定单击事件
    $("#batchRemoveBtn").click(function () {
      // 创建一个数组对象，用来存放后面获得的角色对象
      let roleArray = [];
      // 遍历被勾选的内容
      $(".itemBox:checked").each(function () {
        // 通过this引用当前遍历得到的多选框的id
        let roleId = this.id;
        // 通过DOM操作获取角色名称
        let roleName = $(this).parent().next().text();
        roleArray.push({
          "id": roleId,
          "name": roleName
        });
      });
      // 判断roleArray的长度是否为0
      if (roleArray.length == 0) {
        layer.msg("请至少选择一个来删除");
        return;
      }
      // 显示确认框
      showConfirmModal(roleArray);
    });

    // 单击全选框时，使下面的内容全选/全不选
    $("#summaryBox").click(function () {
      // 获取当前状态（是否被选中）
      let currentStatus = this.checked;
      $(".itemBox").prop("checked", currentStatus);
    });

    // 由下面的选择框，改变全选框的勾选状态
    $("#rolePageBody").on("click", ".itemBox", function () {
      // 获取当前已被选中的itemBox的数量
      let checkedBoxCount = $(".itemBox:checked").length;
      // 获取当前的所有的itemBox数量
      let currentBoxCount = $(".itemBox").length;
      $("#summaryBox").prop("checked", checkedBoxCount == currentBoxCount);
    });

    // 给分配权限的按钮添加单击响应函数，打开分配模态框
    $("#rolePageBody").on("click", ".checkBtn", function () {
      // 将当前按钮的id放入全局变量
      window.roleId = this.id;
      // 打开模态框
      $("#assignModal").modal("show");
      // 生成权限信息
      generateAuthTree();
    });

    // 给分配权限的模态框中的提交按钮设置单击响应函数
    $("#assignBtn").click(function () {
      // 声明一个数组，用来存放被勾选的auth的id
      let authIdArray = [];
      // 拿到zTreeObj
      let zTreeObj = $.fn.zTree.getZTreeObj("authTreeDemo");
      // 通过getCheckedNodes方法拿到被选中的option信息
      let authArray = zTreeObj.getCheckedNodes();

      for (let i = 0; i < authArray.length; i++) {
        // 从被选中的auth中遍历得到每一个auth的id
        let authId = authArray[i].id;
        // 通过push方法将得到的id存入authIdArray
        authIdArray.push(authId);
      }
      let requestBody = {
        // 为了后端取值方便，两个数据都用数组格式存放，后端统一用List<Integer>获取
        "roleId": [window.roleId],
        "authIdList": authIdArray
      }
      requestBody = JSON.stringify(requestBody);
      $.ajax({
        url: "assign/do/save/role/auth/relationship.json",
        type: "post",
        data: requestBody,
        contentType: "application/json;charset=UTF-8",
        dataType: "json",
        success: function (response) {
          if (response.result == "SUCCESS") {
            layer.msg("操作成功！");
          }
          if (response.result == "FAILED") {
            layer.msg("操作失败！提示信息：" + response.message);
          }
        },
        error: function (response) {
          layer.msg(response.status + "  " + response.statusText);
        }
      });
      // 关闭模态框
      $("#assignModal").modal("hide");
    });
  });
</script>
<body>
<%@include file="/WEB-INF/include-nav.jsp" %>
<div class="container-fluid">
    <div class="row">
        <%@include file="/WEB-INF/include-sidebar.jsp" %>
        <div class="col-sm-9 col-sm-offset-3 col-md-10 col-md-offset-2 main">
            <div class="panel panel-default">
                <div class="panel-heading">
                    <h3 class="panel-title"><i class="glyphicon glyphicon-th"></i> 数据列表</h3>
                </div>
                <div class="panel-body">
                    <form class="form-inline" role="form" style="float:left;">
                        <div class="form-group has-feedback">
                            <div class="input-group">
                                <div class="input-group-addon">查询条件</div>
                                <input id="inputKeyword" class="form-control has-success" type="text"
                                       placeholder="请输入查询条件">
                            </div>
                        </div>
                        <button id="searchBtn" type="button" class="btn btn-warning"><i
                                class="glyphicon glyphicon-search"></i> 查询
                        </button>
                    </form>
                    <button id="batchRemoveBtn" type="button" class="btn btn-danger" style="float:right;margin-left:10px;"><i
                            class=" glyphicon glyphicon-remove"></i> 删除
                    </button>
                    <button id="showAddModalBtn" type="button" class="btn btn-primary" style="float:right;"><i
                            class="glyphicon glyphicon-plus"></i> 新增
                    </button>
                    <br>
                    <hr style="clear:both;">
                    <div class="table-responsive">
                        <table class="table  table-bordered">
                            <thead>
                            <tr>
                                <th width="30">#</th>
                                <th width="30"><input type="checkbox" id="summaryBox"></th>
                                <th>名称</th>
                                <th width="100">操作</th>
                            </tr>
                            </thead>
                            <tbody id="rolePageBody"></tbody>
                            <tfoot>
                            <tr>
                                <td colspan="6" align="center">
                                    <ul id="Pagination" class="pagination"></ul>
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

<%--在最后引入模态框--%>
<%@include file="/WEB-INF/modal-role-add.jsp" %>
<%@include file="/WEB-INF/modal-role-edit.jsp" %>
<%@include file="/WEB-INF/modal-role-confirm.jsp"%>
<%@include file="/WEB-INF/modal-role-assign-auth.jsp"%>
</body>
</html>
