Munit.suite = (defs = {}) ->
  for name, suite of defs
    # Ensure the suite of tests is named.
    suite.name ?= _.humanize(name)

    # Convert an object of tests into an array.
    if _.isObject(suite.tests)
      tests = []
      for key, test of suite.tests
        test = { func:test } if _.isFunction(test)
        test.name ?= _.humanize(key)
        tests.push(test)
      suite.tests = tests

    # Register the test suite.
    Munit.run(suite)



# --------------------------------------------------------------------------





