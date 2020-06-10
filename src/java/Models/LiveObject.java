package Models;

import com.j256.ormlite.dao.Dao;
import com.j256.ormlite.dao.DaoManager;
import com.j256.ormlite.support.ConnectionSource;
import java.sql.SQLException;

/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
/**
 *
 * @author Evan
 */
abstract class LiveObject<THIS extends LiveObject<THIS>> {

    public Dao<THIS, Object> getDao(ConnectionSource cs) throws SQLException {
        return DaoManager.createDao(cs, (Class<THIS>) this.getClass());
    }
}
