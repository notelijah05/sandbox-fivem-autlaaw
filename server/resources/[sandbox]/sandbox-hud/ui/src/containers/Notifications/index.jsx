import React, { useEffect, useMemo } from 'react';
import { useSelector } from 'react-redux';
import { makeStyles } from '@mui/styles';

import Notification from './components/Notification';

const useStyles = makeStyles((theme) => ({
    wrapper: {
        maxWidth: 400,
        height: 'fit-content',
        width: '100%',
        position: 'absolute',
        padding: 10,
        right: 0,
        top: 0,
    },
}));

export default () => {
    const classes = useStyles();

    const notifications = useSelector(
        (state) => state.notification.notifications,
    );

    const pers = useMemo(
        () => notifications.filter((n) => n.duration <= 0),
        [notifications],
    );
    const notifs = useMemo(
        () => notifications.filter((n) => n.duration > 0),
        [notifications],
    );

    return (
        <div className={classes.wrapper}>
            {pers.length > 0 &&
                pers
                    .sort((a, b) => b.created - a.created)
                    .map((n) => {
                        return <Notification key={n._id} notification={n} />;
                    })}

            {notifs.length > 0 &&
                notifs
                    .sort((a, b) => b.created - a.created)
                    .map((n) => {
                        return <Notification key={n._id} notification={n} />;
                    })}
        </div>
    );
};
