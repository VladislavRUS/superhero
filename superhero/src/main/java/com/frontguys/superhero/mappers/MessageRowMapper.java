package com.frontguys.superhero.mappers;

import com.frontguys.superhero.models.Message;
import org.springframework.jdbc.core.RowMapper;

import java.sql.ResultSet;
import java.sql.SQLException;

public class MessageRowMapper implements RowMapper {
    @Override
    public Object mapRow(ResultSet resultSet, int i) throws SQLException {
        Message message = new Message();

        message.setId(resultSet.getInt("id"));
        message.setResponseId(resultSet.getInt("response_id"));
        message.setSenderId((Integer) resultSet.getObject("sender_id"));
        message.setText(resultSet.getString("text"));
        message.setTimestamp(resultSet.getString("timestamp"));
        message.setSystem(resultSet.getBoolean("is_system"));

        return message;
    }
}
