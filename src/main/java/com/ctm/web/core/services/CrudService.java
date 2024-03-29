package com.ctm.web.core.services;

import com.ctm.web.core.exceptions.CrudValidationException;
import com.ctm.web.core.exceptions.DaoException;

import javax.servlet.http.HttpServletRequest;
import java.util.List;

public interface CrudService<T> {

    List<?> getAll(HttpServletRequest request) throws DaoException;

    T update(HttpServletRequest request) throws DaoException, CrudValidationException;

    T create(HttpServletRequest request) throws DaoException, CrudValidationException;

    String delete(HttpServletRequest request) throws DaoException, CrudValidationException;

    T get(HttpServletRequest request) throws DaoException, CrudValidationException;

}
