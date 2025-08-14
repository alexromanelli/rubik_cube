enum TextAlias { readerInstruction, preReaderInstruction }

class Strings {
  static final Map<TextAlias, String> strings = <TextAlias, String>{
    TextAlias.readerInstruction: "Selecione uma cor e clique em uma peça do cubo para colorir.",
    TextAlias.preReaderInstruction: "Posicione os lados do cubo como mostra o conjunto de imagens.",
  };
}
