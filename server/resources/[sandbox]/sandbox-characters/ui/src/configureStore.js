import { applyMiddleware, createStore } from 'redux';
import thunk from 'redux-thunk';
import createReducer from './reducers';

export default function configureStore(initialState) {
	const store = createStore(
		createReducer(),
		initialState,
		applyMiddleware(thunk),
	);

	if (import.meta && import.meta.hot) {
		import.meta.hot.accept(['./reducers'], () => {
			store.replaceReducer(createReducer(store.injectedReducers));
		});
	}

	return store;
}
