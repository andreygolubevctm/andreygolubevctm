package com.ctm.services.simples.admin;

import com.ctm.exceptions.CrudValidationException;
import com.ctm.exceptions.DaoException;

import javax.servlet.http.HttpServletRequest;
import java.util.List;

public interface CrudService<T> {

    List<?> getAll() throws DaoException;

    T update(HttpServletRequest request) throws DaoException, CrudValidationException;

    T create(HttpServletRequest request) throws DaoException, CrudValidationException;

    String delete(HttpServletRequest request) throws DaoException, CrudValidationException;

    T get(HttpServletRequest request) throws DaoException, CrudValidationException;

}
