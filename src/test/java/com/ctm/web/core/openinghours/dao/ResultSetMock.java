package com.ctm.web.core.openinghours.dao;

import org.mockito.Mockito;
import org.mockito.invocation.InvocationOnMock;
import org.mockito.stubbing.Answer;
import org.springframework.util.Assert;

import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

public class ResultSetMock {

    static ResultSet mockResultSet(List<String> columns, Object... values) {
        Assert.isTrue(values.length % columns.size() == 0,
                String.format( "Number of values [%d] must be a multiple of the number of columns [%d]", values.length, columns.size())
        );
        return Mockito.mock(ResultSet.class, new ResultSetAnswer(convertValues(columns, values)));
    }

    private static List<Map<String, Object>> convertValues(List<String> columns, Object[] values) {
        List<Map<String, Object>> result = new ArrayList<>();

        int index = 0;
        while (index < values.length) {
            Map<String, Object> row = new HashMap<>();
            result.add(row);
            for (String column : columns) {
                row.put(column, values[index]);
                index++;
            }
        }
        return result;
    }

    private static class ResultSetAnswer implements Answer {
        private final List<Map<String, Object>> values;
        private int index = -1;

        public ResultSetAnswer(List<Map<String, Object>> values) {
            this.values = values;
        }

        @Override
        public Object answer(InvocationOnMock invocation) throws Throwable {
            if (invocation.getMethod().getName().equals("next"))
                return next();

            Object[] arguments = invocation.getArguments();
            if (arguments.length > 0) {
                return getObject((String) arguments[0]);
            }
            if (invocation.getMethod().getName().equals("close"))
                return true;
            return false;
        }

        private Object getObject(String column) {
            return values.get(index).get(column);
        }

        private boolean next() {
            index++;
            return index < values.size();
        }
    }
}
