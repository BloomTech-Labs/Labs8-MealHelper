// import {
// 	ADDING_USER,
// 	ADDED_USER,
// 	GETTING_USER,
// 	GOT_USER,
// 	DELETING_USER,
// 	DELETED_USER,
// 	CHANGING_USER,
// 	CHANGED_USER,
// 	ERROR
// } from "../actions/userActions";
// import axios from "axios";

// let initialState = {
// 	users: [],
// 	addingUser: false,
// 	gettingUser: false,
//     deletingUser:false,
//     changingUser: false,
// 	error: null
// };

// export const noteReducer = (state = initialState, action) => {
// 	switch (action.type) {
// 		case ADDING_USER:
// 			return { ...state, addingUser: true };
// 		case ADDED_USER:
// 			return { ...state,  addingUser: false, users: action.payload };
// 		case ADDING_USER_ERROR:
// 			return { ...state, fetchingNotes: false, error: action.payload };
// 		case UPDATING_NOTE:
// 			return { ...state, updatingNotes: true };
// 		case UPDATED_NOTE:
// 			return { ...state, updatingNotes: false, notes: action.payload };
// 		case UPDATING_NOTE_ERROR:
// 			return { ...state, updatingNotes: false, error: action.payload };
// 		case ADDING_NOTE:
// 			return { ...state, addingNotes: true };
// 		case ADDED_NOTE:
// 			return {
// 				...state,
// 				addingNotes: false,
// 				notes: action.payload
// 			};
// 		case ADDING_NOTE_ERROR:
// 			return { ...state, addingNotes: false, error: action.payload };

// 		case DELETING_NOTE:
// 			return { ...state, deletingNote: true };
// 		case DELETED_NOTE:
// 			return { ...state, deletingNote: false, notes: action.payload };
// 		case DELETED_NOTE_ERROR:
// 			return { ...state, deletingNote: false, error: action.payload };
// 		default:
// 			return state;
// 	}
// };
