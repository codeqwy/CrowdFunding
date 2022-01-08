package com.codeqwy.crowd.util;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

/**
 * @Author CodeQwy
 * @Date 2022/1/7 16:35
 * @Description ResultEntity
 */

@Data
@NoArgsConstructor
@AllArgsConstructor
public class ResultEntity<T> {
    public static final String SUCCESS = "SUCCESS";
    public static final String FAILED = "FAILED";
    // public static final String NO_MESSAGE = "NO_MESSAGE";
    // public static final String NO_DATA = "NO_DATA";

    // 用来封装当前请求处理的结果是成功还是失败
    private String result;
    // 请求处理失败时返回的错误信息
    private String message;
    // 要返回的数据
    private T queryData;

    /**
     * 请求处理成功且不需要返回数据时使用的工具方法
     *
     * @param <E> 泛型
     * @return
     */
    public static <E> ResultEntity<E> successWithoutData() {
        return new ResultEntity<E>(SUCCESS, null, null);
    }

    /**
     * 请求处理成功且需要返回数据时使用的工具方法
     *
     * @param data
     * @param <E>
     * @return
     */
    public static <E> ResultEntity<E> successWithData(E data) {
        return new ResultEntity<E>(SUCCESS, null, data);
    }

    /**
     * 请求处理失败且需要返回信息时使用的工具方法
     *
     * @param message
     * @param <E>
     * @return
     */
    public static <E> ResultEntity<E> failed(String message) {
        return new ResultEntity<E>(FAILED, message, null);
    }
}
