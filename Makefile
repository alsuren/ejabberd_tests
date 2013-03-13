.PHONY: all test console compile
all: test

test_clean: get-deps
	rm -rf tests/*.beam
	make test

cover_test_clean: get-deps
	rm -rf tests/*.beam
	make cover_test

test: prepare
	erl -noinput -sname test -setcookie ejabberd \
		-pa `pwd`/tests \
			`pwd`/deps/*/ebin \
		-s run_common_test ct

trace_network: prepare
	erl -sname test -setcookie ejabberd \
		-pa `pwd`/tests \
			`pwd`/deps/*/ebin \
		-s run_common_test ct_trace escalus_connection

debug_test: prepare
	erl -sname test -setcookie ejabberd \
		-pa `pwd`/tests \
			`pwd`/deps/*/ebin \
		-s run_common_test ct_debug


%_SUITE: prepare
	ct_run -pa `pwd`/deps/*/ebin \
		-config test.config \
		-suite tests/$@

cover_test: prepare
	erl -noinput -sname test -setcookie ejabberd \
		-pa `pwd`/tests \
			`pwd`/deps/*/ebin \
		-s run_common_test ct_cover; \

cover_summary: prepare
	erl -noinput -sname test -setcookie ejabberd \
		-pa `pwd`/tests \
			`pwd`/deps/*/ebin \
		-s run_common_test cover_summary; \

prepare: compile
	erlc -Ideps/exml/include \
		 run_common_test.erl
	mkdir -p ct_report

console: prepare
	erl -sname test -setcookie ejabberd \
		-pa `pwd`/tests \
			`pwd`/deps/*/ebin \

compile: get-deps
	./rebar compile

get-deps: rebar
	./rebar get-deps

clean: rebar
	./rebar clean

rebar:
	wget http://cloud.github.com/downloads/basho/rebar/rebar
	chmod u+x rebar
