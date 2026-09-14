from app.routes.user import hash_password, verify_password


def test_hash_password_does_not_return_plaintext():
	password = "correct horse battery staple"

	hashed_password = hash_password(password)

	assert hashed_password != password


def test_hash_password_returns_different_hashes_for_same_password():
	password = "correct horse battery staple"

	first_hash = hash_password(password)
	second_hash = hash_password(password)

	assert first_hash != second_hash


def test_verify_password_returns_true_for_correct_password():
	password = "correct horse battery staple"
	hashed_password = hash_password(password)

	assert verify_password(password, hashed_password) is True


def test_verify_password_returns_false_for_incorrect_password():
	hashed_password = hash_password("correct horse battery staple")

	assert verify_password("incorrect password", hashed_password) is False
