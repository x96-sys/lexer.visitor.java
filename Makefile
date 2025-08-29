BUILD_DIR     = out
MAIN_BUILD    = $(BUILD_DIR)/main
TEST_BUILD    = $(BUILD_DIR)/test

SRC_MAIN      = src/main
SRC_TEST      = src/test

TOOLS_DIR     = tools
LIB_DIR       = lib

IO_VERSION = 1.1.0
IO_JAR     = $(LIB_DIR)/org.x96.sys.io.jar
IO_URL     = https://github.com/x96-sys/io.java/releases/download/v$(IO_VERSION)/org.x96.sys.io.jar
IO_SHA256  = e18d2fdb894386bd24bb08f178e4a6566d7feadaaf8e96d32bd6d9c5dc63c474

BUZZ_VERSION = 1.0.0
BUZZ_JAR     = $(LIB_DIR)/org.x96.sys.buzz.jar
BUZZ_URL     = https://github.com/x96-sys/buzz.java/releases/download/v$(BUZZ_VERSION)/org.x96.sys.buzz.jar
BUZZ_SHA256  = c4f30d580a9dea5db83f0dd0256de247ca217e62f401e5c06392c5b61909efa1

KIND_VERSION = 1.0.0
KIND_JAR     = $(LIB_DIR)/org.x96.sys.lexer.token.kind.jar
KIND_URL     = https://github.com/x96-sys/lexer.token.kind.java/releases/download/v$(KIND_VERSION)/org.x96.sys.lexer.token.kind.jar
KIND_SHA256  = 55d12618cd548099d138cbc1e7beda2b78e6a09382ec725523e82f7eb5a31c69

TOKEN_VERSION = 1.0.0
TOKEN_JAR     = $(LIB_DIR)/org.x96.sys.lexer.token.jar
TOKEN_URL     = https://github.com/x96-sys/cs.lexer.token.java/releases/download/v$(TOKEN_VERSION)/org.x96.sys.lexer.token.jar
TOKEN_SHA256  = b58fa314148954ec78d3ead11a434da2670d6d64837807087d2b541190fcf40d

TOKENIZER_VERSION = 1.0.0
TOKENIZER_JAR     = $(LIB_DIR)/org.x96.sys.lexer.tokenizer.jar
TOKENIZER_URL     = https://github.com/x96-sys/lexer.tokenizer.java/releases/download/v$(TOKENIZER_VERSION)/org.x96.sys.lexer.tokenizer.jar
TOKENIZER_SHA256  = 21a10167ffd798f1fa9cbbda1382650a411c826b957bf3cc607863696bf4e8f7

ROUTER_VERSION = 0.2.0
ROUTER_JAR     = $(LIB_DIR)/org.x96.sys.lexer.router.jar
ROUTER_URL     = https://github.com/x96-sys/cs.lexer.router.java/releases/download/v$(ROUTER_VERSION)/org.x96.sys.lexer.router.jar
ROUTER_SHA256  = 88ebc66c8da8fc7056716b4cc8ce24cd1f6a487e3fb9d3d7173cfd95f0c6719b

CS_AST_VERSION = 1.0.0
CS_AST_JAR     = $(LIB_DIR)/org.x96.sys.cs.ast.jar
CS_AST_URL     = https://github.com/x96-sys/cs.ast.java/releases/download/v$(CS_AST_VERSION)/org.x96.sys.cs.ast.jar
CS_AST_SHA256  = 2a6a395ea6defdde47d5c9855dd83d47d4cf0d233f3789c3e95094e85b4597a4

JUNIT_VERSION = 1.13.4
JUNIT_JAR     = $(TOOLS_DIR)/junit-platform-console-standalone.jar
JUNIT_URL     = https://maven.org/maven2/org/junit/platform/junit-platform-console-standalone/$(JUNIT_VERSION)/junit-platform-console-standalone-$(JUNIT_VERSION).jar
JUNIT_SHA256  = 3fdfc37e29744a9a67dd5365e81467e26fbde0b7aa204e6f8bbe79eeaa7ae892

JACOCO_VERSION = 0.8.13
JACOCO_BASE    = https://maven.org/maven2/org/jacoco

JACOCO_CLI_VERSION = $(JACOCO_VERSION)
JACOCO_CLI_JAR     = $(TOOLS_DIR)/jacococli.jar
JACOCO_CLI_URL     = $(JACOCO_BASE)/org.jacoco.cli/$(JACOCO_CLI_VERSION)/org.jacoco.cli-$(JACOCO_CLI_VERSION)-nodeps.jar
JACOCO_CLI_SHA256  = 8f748683833d4dc4d72cea5d6b43f49344687b831e0582c97bcb9b984e3de0a3

JACOCO_AGENT_VERSION = $(JACOCO_VERSION)
JACOCO_AGENT_JAR     = $(TOOLS_DIR)/jacocoagent-runtime.jar
JACOCO_AGENT_URL     = $(JACOCO_BASE)/org.jacoco.agent/$(JACOCO_AGENT_VERSION)/org.jacoco.agent-$(JACOCO_AGENT_VERSION)-runtime.jar
JACOCO_AGENT_SHA256  = 47e700ccb0fdb9e27c5241353f8161938f4e53c3561dd35e063c5fe88dc3349b

GJF_VERSION = 1.28.0
GJF_JAR     = $(TOOLS_DIR)/gjf.jar
GJF_URL     = https://maven.org/maven2/com/google/googlejavaformat/google-java-format/$(GJF_VERSION)/google-java-format-$(GJF_VERSION)-all-deps.jar
GJF_SHA256  = 32342e7c1b4600f80df3471da46aee8012d3e1445d5ea1be1fb71289b07cc735

BUILD_INFO = https://gist.githubusercontent.com/tfs91/7c050b5c822c6f247aa0ab193be3d35d/raw/8d91e9f98dce6f606b7a375ab76891906f9b08dc/gen_build_info.rb

JAVA_SOURCES = $(shell find $(SRC_MAIN) -name "*.java")

DISTRO_JAR = org.x96.sys.lexer.visitor.jar

CP = $(CS_AST_JAR):$(IO_JAR):$(TOKEN_JAR):$(KIND_JAR):$(TOKENIZER_JAR):$(BUZZ_JAR):$(ROUTER_JAR)

build/info:
  @curl -sSL $(BUILD_INFO) | ruby - src/main/ org.x96.sys.lexer.visitor

build: build/info libs
	@javac --version
	@javac -d $(MAIN_BUILD) -cp $(CP) $(JAVA_SOURCES)
	@echo "✅ Compilação concluída com sucesso!"

build/test:
	@javac -Xlint:deprecation -cp $(MAIN_BUILD):$(JUNIT_JAR):$(CP) -d $(TEST_BUILD) \
     $(shell find $(SRC_TEST) -name "*.java")
	@echo "✅ Compilação de testes concluída com sucesso!"

test: kit clean/build/test clean/build build build/test
	@java -jar $(JUNIT_JAR) \
     execute \
     --class-path $(TEST_BUILD):$(MAIN_BUILD):$(CP) \
     --scan-class-path

coverage-run: build/test tools/jacoco
	@java -javaagent:$(JACOCO_AGENT_JAR)=destfile=$(BUILD_DIR)/jacoco.exec \
       -jar $(JUNIT_JAR) \
       execute \
       --class-path $(TEST_BUILD):$(MAIN_BUILD):$(CP) \
       --scan-class-path

coverage-report: tools/jacoco
	@java -jar $(JACOCO_CLI_JAR) report \
     $(BUILD_DIR)/jacoco.exec \
     --classfiles $(MAIN_BUILD) \
     --sourcefiles $(SRC_MAIN) \
     --html $(BUILD_DIR)/coverage \
     --name "Coverage Report"

coverage: coverage-run coverage-report
	@echo "✅ Relatório de cobertura disponível em: build/coverage/index.html"
	@echo "🌐 Abrir com: open out/coverage/index.html"

test-method: build/test ## Executa teste específico (METHOD="org.x96.sys.foundation.cs.lexer.visitor.entry.terminals.c4.LatinCapitalLetterITest#happy")
	@echo "🧪 Executando teste: $(METHOD)"
	@java -jar $(JUNIT_JAR) --class-path $(TEST_BUILD):$(MAIN_BUILD):$(CP) --select "method:$(METHOD)"

test-class: build/test ## Executa classe de teste (CLASS="nome.da.Classe")
	@echo "🧪 Executando classe: $(CLASS)"
	@java -jar $(JUNIT_JAR) --class-path $(TEST_BUILD):$(MAIN_BUILD):$(CP) --select "class:$(CLASS)"

distro:
	@jar cf $(DISTRO_JAR) -C $(MAIN_BUILD) .
	@echo "✅ Distribuição criada com sucesso! $(DISTRO_JAR)"

tools/jacoco: tools/jacoco_cli tools/jacoco_agent

build/info:
	@curl -sSL $(BUILD_INFO) | ruby - $(SRC_MAIN) org.x96.sys.lexer.visitor

format: tools/gjf
	find src -name "*.java" -print0 | xargs -0 java -jar $(GJF_JAR) --aosp --replace

$(LIB_DIR) $(TOOLS_DIR) $(MAIN_BUILD) $(TEST_BUILD):
	@mkdir -p $@

define deps
$1/$2: $1
	@expected="$($3_SHA256)"; \
	jar="$($3_JAR)"; \
	url="$($3_URL)"; \
	tmp="$$$$(mktemp)"; \
	if [ ! -f "$$$$jar" ]; then \
		echo "[📦] [🚛] [$($3_VERSION)] [$2]"; \
		curl -sSL -o "$$$$tmp" "$$$$url"; \
		actual="$$$$(shasum -a 256 $$$$tmp | awk '{print $$$$1}')"; \
		if [ "$$$$expected" = "$$$$actual" ]; then mv "$$$$tmp" "$$$$jar"; \
		echo "[📦] [📍] [$($3_VERSION)] [$2] [🐚]"; else rm "$$$$tmp"; \
		echo "[❌] [hash mismatch] [$2]"; exit 1; fi; \
	else \
		actual="$$$$(shasum -a 256 $$$$jar | awk '{print $$$$1}')"; \
		if [ "$$$$expected" = "$$$$actual" ]; \
		then echo "[📦] [📍] [$($3_VERSION)] [🐚] [$2]"; \
		else \
			echo "[❌] [hash mismatch] [$2]"; \
			curl -sSL -o "$$$$tmp" "$$$$url"; \
			actual="$$$$(shasum -a 256 $$$$tmp | awk '{print $$$$1}')"; \
			if [ "$$$$expected" = "$$$$actual" ]; then mv "$$$$tmp" "$$$$jar"; \
			echo "[📦] [♻️] [$($3_VERSION)] [🐚] [$2]"; else rm "$$$$tmp"; \
			echo "[❌] [download failed] [$2]"; exit 1; fi; \
		fi; \
	fi
endef

libs: \
	lib/io \
	lib/token \
	lib/kind \
	lib/tokenizer \
	lib/cs-router \
	lib/cs-ast \
	lib/buzz

$(eval $(call deps,lib,io,IO))
$(eval $(call deps,lib,token,TOKEN))
$(eval $(call deps,lib,tokenizer,TOKENIZER))
$(eval $(call deps,lib,kind,KIND))
$(eval $(call deps,lib,cs-router,ROUTER))
$(eval $(call deps,lib,cs-ast,CS_AST))
$(eval $(call deps,lib,buzz,BUZZ))

kit: tools/gjf tools/junit tools/jacoco_cli tools/jacoco_agent

$(eval $(call deps,tools,gjf,GJF))
$(eval $(call deps,tools,junit,JUNIT))
$(eval $(call deps,tools,jacoco_cli,JACOCO_CLI))
$(eval $(call deps,tools,jacoco_agent,JACOCO_AGENT))

clean/build:
	@rm -rf $(MAIN_BUILD)
	@echo "[🧹] [clean] [$(MAIN_BUILD)]"

clean/build/test:
	@rm -rf $(TEST_BUILD)
	@echo "[🧹] [clean] [$(TEST_BUILD)]"

clean:
	@rm -rf $(BUILD_DIR) $(TOOLS_DIR) $(LIB_DIR)
	@echo "[🧹] [clean] [$(BUILD_DIR)]"
	@echo "[🧹] [clean] [$(LIB_DIR)]"
	@echo "[🧹] [clean] [$(TOOLS_DIR)]"
