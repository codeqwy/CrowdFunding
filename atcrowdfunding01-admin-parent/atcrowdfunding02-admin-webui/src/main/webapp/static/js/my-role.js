// 执行分页，生成页面效果，任何时候调用这个函数都会重新加载页面
function generatePage() {
  // 1.获取页面数据
  let pageInfo = getPageInfoRemote();
  // console.log(pageInfo)
  // 2.填充表格
  fillTableBody(pageInfo);
}

// 远程访问服务器端程序，获取 pageInfo 数据
function getPageInfoRemote() {
  // 调用 $.ajax() 函数发送请求并接受 $.ajax() 函数的返回值
  let ajaxResult = $.ajax({
    url: "role/get/page/info.json",
    type: "post",
    data: {
      pageNum: window.pageNum,
      pageSize: window.pageSize,
      keyword: window.keyword
    },
    async: false,
    dataType: "json"
  });

  // console.log(ajaxResult);
  // 判断当前状态码是否为 200
  let statusCode = ajaxResult.status;
  // 如果当前状态码不是 200，说明发生了错误或其他意外情况，显示错误信息
  if (statusCode !== 200) {
    layer.msg("失败！响应状态码：" + statusCode + "，说明信息：" + ajaxResult.statusText);
    return null;
  }
  // 请求处理成功，获取 pageInfo
  let resultEntity = ajaxResult.responseJSON;
  // console.log(resultEntity);
  // 从 resultEntity 中获取 result 属性
  let result = resultEntity.result;
  // console.log(result);
  // 判断 result 是否成功
  if (result == "FAILED") {
    layer.msg(resultEntity.message);
    return null;
  }
  // 返回 pageInfo
  return resultEntity.queryData;
}

// 填充表格
function fillTableBody(pageInfo) {
  // 清除tbody中的旧内容
  $("#rolePageBody").empty();
  // 使无查询结果时，不显示导航条
  $("#Pagination").empty();
  if (pageInfo == null || pageInfo == undefined || pageInfo.list == null || pageInfo.list.length === 0) {
    $("#rolePageBody").append("<tr><td colspan='4'>抱歉！没有查询到您搜索的数据！</td></tr>");
    return;
  }
  // console.log(pageInfo.list.length)
  for (let i = 0; i < pageInfo.list.length; i++) {
    let role = pageInfo.list[i];
    let roleId = role.id;
    let roleName = role.name;
    let numberTd = "<td>" + (i + 1) + "</td>";
    let checkboxTd = "<td><input type='checkbox' id='" + roleId + "' class='itemBox'/></td>";
    let roleNameTd = "<td>" + roleName + "</td>";
    let checkBtn = "<button type='button' id='" + roleId + "' class='btn btn-success btn-xs checkBtn'><i class=' glyphicon glyphicon-check'></i></button>"
    // 铅笔按钮用于修改role信息。用id属性（也可以是其他属性）携带当前的角色的id，class添加一个pencilBtn，方便添加响应函数
    let pencilBtn = "<button type='button' id='" + roleId + "' class='btn btn-primary btn-xs pencilBtn'><i class=' glyphicon glyphicon-pencil'></i></button>"
    let removeBtn = "<button type='button' id='" + roleId + "' class='btn btn-danger btn-xs removeBtn'><i class=' glyphicon glyphicon-remove'></i></button>"
    let buttonTd = "<td>" + checkBtn + " " + pencilBtn + " " + removeBtn + "</td>";
    let tr = "<tr>" + numberTd + checkboxTd + roleNameTd + buttonTd + "</tr>";
    $("#rolePageBody").append(tr);
  }
  // 进行生成分页页码导航条
  generateNavigator(pageInfo);
}

// 生成分页页码导航条
function generateNavigator(pageInfo) {
  //获取分页数据中的总记录数
  let totalRecord = pageInfo.total;
  //声明Pagination设置属性的JSON对象
  let properties = {
    num_edge_entries: 3,                                //边缘页数
    num_display_entries: 5,                             //主体页数
    callback: paginationCallBack,                       //点击各种翻页反扭时触发的回调函数（执行翻页操作）
    current_page: (pageInfo.pageNum - 1),                 //当前页码
    prev_text: "上一页",                                 //在对应上一页操作的按钮上的文本
    next_text: "下一页",                                 //在对应下一页操作的按钮上的文本
    items_per_page: pageInfo.pageSize   //每页显示的数量
  };
  $("#Pagination").pagination(totalRecord, properties);

}

// 翻页时的回调函数
function paginationCallBack(pageIndex, jQuery) {
  // pageIndex是当前页码的索引，因此比pageNum小1
  window.pageNum = pageIndex + 1;
  // 重新执行分页代码
  generatePage();
  // 取消当前超链接的默认行为
  return false;
}

// 打开确认删除的模态框
function showConfirmModal(roleArray) {
  // 显示模态框
  $("#confirmRoleModal").modal("show");
  // 清除旧的模态框中的数据
  $("#confirmList").empty();
  // 创建一个全局变量数组，用于存放要删除的roleId
  window.roleIdArray = [];
  // 填充数据
  for (let i = 0; i < roleArray.length; i++) {
    let roleId = roleArray[i].id;
    // 将当前遍历到的roleId放入全局变量
    window.roleIdArray.push(roleId);
    let roleName = roleArray[i].name;
    $("#confirmList").append(roleName + "<br/>");
  }
}

// -----------------------

// 生成权限信息的树形结构
function generateAuthTree() {
  let ajaxReturn = $.ajax({
    url: "assign/get/auth.json",
    type: "post",
    async: false,
    dataType: "json"
  });
  // console.log(ajaxReturn);
  if (ajaxReturn.status != 200) {
    layer.msg("请求出错！错误码：" + ajaxReturn.status + "错误信息：" + ajaxReturn.statusText);
    return;
  }
  let resultEntity = ajaxReturn.responseJSON;
  if (resultEntity.result == "FAILED") {
    layer.msg("操作失败！" + resultEntity.message);
  }
  if (resultEntity.result == "SUCCESS") {
    let authList = resultEntity.queryData;
    // 将服务端查询到的list交给zTree自己组装
    let setting = {
      data: {
        // 开启简单JSON功能
        simpleData: {
          enable: true,
          // 通过pIdKey属性设置父节点的属性名，而不使用默认的pId
          pIdKey: "categoryId"
        },
        key: {
          // 设置在前端显示的节点名是查询到的title，而不是使用默认的name
          name: "title"
        },
      },
      check: {
        enable: true
      }
    };
    // 生成树形结构信息
    $.fn.zTree.init($("#authTreeDemo"), setting, authList);
    // 设置节点默认是展开的
    // 1 得到zTreeObj
    let zTreeObj = $.fn.zTree.getZTreeObj("authTreeDemo");
    // 2 设置默认展开
    zTreeObj.expandAll(true);
    // 勾选后端查出的匹配的权限
    ajaxReturn = $.ajax({
      url: "assign/get/assigned/auth/id/by/role/id.json",
      type: "post",
      dataType: "json",
      async: false,
      data: {
        "roleId": window.roleId
      }
    });
    if (ajaxReturn.status != 200) {
      layer.msg("请求出错！错误码：" + ajaxReturn.status + "错误信息：" + ajaxReturn.statusText);
      return;
    }
    resultEntity = ajaxReturn.responseJSON;
    if (resultEntity.result == "FAILED") {
      layer.msg("操作失败！" + resultEntity.message);
    }
    if (resultEntity.result == "SUCCESS") {
      let authIdArray = resultEntity.queryData;
      // 遍历得到的autoId的数组
      // 根据authIdArray勾选对应的节点
      for (let i = 0; i < authIdArray.length; i++) {
        let authId = authIdArray[i];
        // 通过id得到treeNode
        let treeNode = zTreeObj.getNodeByParam("id", authId);
        // checked设置为true，表示勾选节点
        let checked = true;
        // checkTypeFlag设置为false，表示不联动勾选，
        // 即父节点的子节点未完全勾选时不改变父节点的勾选状态
        let checkTypeFlag = false;
        // 执行勾选操作
        zTreeObj.checkNode(treeNode, checked, checkTypeFlag);
      }
    }
  }
}