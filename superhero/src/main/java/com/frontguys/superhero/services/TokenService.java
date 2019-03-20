package com.frontguys.superhero.services;

import com.frontguys.superhero.dao.TokenDAO;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

@Service
public class TokenService {
    @Autowired
    TokenDAO tokenDAO;

    public boolean validateToken(String token){
        return tokenDAO.validateToken(token);
    }
}
