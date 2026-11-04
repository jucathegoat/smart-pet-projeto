import os

# Mapeamento completo de caracteres corrompidos, letras e emojis
REPLACEMENTS = {
    # === LETRAS E ACENTUAÇÃO EM PORTUGUÊS ===
    'Ã§': 'ç', 'Ã‡': 'Ç',
    'Ã£': 'ã', 'Ã\x83': 'Ã',
    'Ã¡': 'á', 'Ã\x81': 'Á',
    'Ã©': 'é', 'Ã\x89': 'É',
    'Ã\xad': 'í', 'Ã\x8d': 'Í',
    'Ã³': 'ó', 'Ã\x93': 'Ó',
    'Ãº': 'ú', 'Ã\x9a': 'Ú',
    'Ã¢': 'â', 'Ã\x82': 'Â',
    'Ãª': 'ê', 'Ã\x8a': 'Ê',
    'Ã´': 'ô', 'Ã\x94': 'Ô',
    'Ã ': 'à', 'Ã\x80': 'À',
    'Ãµ': 'õ', 'Ã\x95': 'Õ',

    # === EMOJIS DE PATINHAS, PETS E ANIMAIS ===
    'ð\x9f\x90\xbe': '🐾', 'ð\x9f\x90\xb6': '🐶', 'ð\x9f\x90\x95': '🐕', 
    'ð\x9f\x90\xae': '🦮', 'ð\x9f\x90\xaf': '🐕‍🦺', 'ð\x9f\x90\xa9': '🐩', 
    'ð\x9f\x90\xb1': '🐱', 'ð\x9f\x90\x88': '🐈', 'ð\x9f\xa6\xb4': '🦴',
    'ð\x9f\x90\xb5': '🐵', 'ð\x9f\x90\x92': '🐒', 'ð\x9f\xa6\xa7': '🦧', 
    'ð\x9f\x90\xb4': '🐴', 'ð\x9f\x90\x8e': '🐎', 'ð\x9f\xa6\x84': '🦄', 
    'ð\x9f\xa6\x93': '🦓', 'ð\x9f\x90\xae': '🐮', 'ð\x9f\x90\x83': '🐂', 
    'ð\x9f\x90\x82': '🐃', 'ð\x9f\x90\x84': '🐄', 'ð\x9f\x90\xb7': '🐷', 
    'ð\x9f\x90\x96': '🐖', 'ð\x9f\x90\x97': '🐗', 'ð\x9f\x90\x91': '🐑', 
    'ð\x9f\x90\x90': '🐐', 'ð\x9f\x90\xaa': '🐪', 'ð\x9f\x90\xab': '🐫', 
    'ð\x9f\xa6\x99': '🦙', 'ð\x9f\xA6\x92': '🦒', 'ð\x9f\x90\x98': '🐘', 
    'ð\x9f\xa6\xa3': '🦣', 'ð\x9f\xa6\x8f': '🦏', 'ð\x9f\xa6\x9b': '🦛', 
    'ð\x9f\x90\xad': '🐭', 'ð\x9f\x90\x81': '🐁', 'ð\x9f\x90\x80': '🐀', 
    'ð\x9f\x90\xb9': '🐹', 'ð\x9f\x90\xb0': '🐰', 'ð\x9f\x90\x87': '🐇', 
    'ð\x9f\x91\xbf': '🐿️', 'ð\x9f\xa6\xab': '🦫', 'ð\x9f\xa6\x94': '🦔', 
    'ð\x9f\xa6\x87': '🦇', 'ð\x9f\x90\xaf': '🐯', 'ð\x9f\x90\x85': '🐅', 
    'ð\x9f\x90\x86': '🐆', 'ð\x9f\x90\xb1': '🦁', 'ð\x9f\x90\xbb': '🐻', 
    'ð\x9f\x90\xbc': '🐼', 'ð\x9f\xa6\xa8': '🦥', 'ð\x9f\xa6\xa6': '🦦', 
    'ð\x9f\xa6\xa1': '🦨', 'ð\x9f\xA6\x99': '🦘', 'ð\x9f\xa6\xa1': '🦡', 
    'ð\x9f\x90\x94': '🐔', 'ð\x9f\x90\x93': '🐓', 'ð\x9f\x90\xa3': '🐣', 
    'ð\x9f\x90\xa4': '🐤', 'ð\x9f\x90\xa5': '🐥', 'ð\x9f\x90\xa6': '🐦', 
    'ð\x9f\x90\xa7': '🐧', 'ð\x9f\x93\x8a': '🕊️', 'ð\x9f\xa6\x85': '🦅', 
    'ð\x9f\xa6\x86': '🦆', 'ð\x9f\xa6\xa2': '🦢', 'ð\x9f\xa6\x89': '🦉', 
    'ð\x9f\xa6\xA4': '🦩', 'ð\x9f\xa6\x9C': '🦜', 'ð\x9f\xa6\xa4': '🦚', 
    'ð\x9f\x90\xb8': '🐸', 'ð\x9f\x90\x8a': '🐊', 'ð\x9f\x90\xa2': '🐢', 
    'ð\x9f\x90\x8d': '🐍', 'ð\x9f\x90\xb3': '🐳', 'ð\x9f\x90\x8b': '🐋', 
    'ð\x9f\x90\xac': '🐬', 'ð\x9f\xa6\xad': '🦭', 'ð\x9f\x90\x9f': '🐟', 
    'ð\x9f\x90\xa0': '🐠', 'ð\x9f\x90\xa1': '🐡', 'ð\x9f\xa6\x88': '🦈', 
    'ð\x9f\x90\x99': '🐙', 'ð\x9f\x90\x9a': '🐚', 'ð\x9f\x90\x8c': '🐌', 
    'ð\x9f\x90\x9b': '🐛', 'ð\x9f\x90\x9c': '🐜', 'ð\x9f\x90\x9d': '🐝', 
    'ð\x9f\x90\x9e': '🐞', 'ð\x9f\x91\xbe': '🕷️', 'ð\x9f\xa6\x82': '🦂', 
    'ð\x9f\x90\x97': '🦟', 'ð\x9f\xa6\xa0': '🦠',
    'ð\x9f\x8f\xaa': '🏪', # Loja de Conveniência / Pet Shop
    'ð\x9f\x8f\xac': '🏬', # Loja / Centro Comercial
    'ð\x9f\x9b\x92': '🛒', # Carrinho de Compras
    'ð\x9f\x8f\xa3': '🏦', # Banco / Pagamento
    'ð\x9f\x92\xb3': '💳', # Cartão de Crédito
    'ð\x9f\x92\xb5': '💵', # Dinheiro
    'ð\x9f\x8f\xa7': '🏧', # Multibanco / ATM
    'ð\x9f\xaa\xa9': '🏷️', # Etiqueta de Preço

    # CARACTERES ESPECÍFICOS DE ERRO E SUBST. GERAL
    'ð%': '🐾',
    'ï¿½': '🐾',
}

EXTENSOES = ('.java', '.jsp', '.dart', '.html', '.css', '.js', '.xml', '.properties', '.json')

def corrigir_ficheiros():
    ficheiros_corrigidos = 0
    for root, _, files in os.walk('.'):
        if any(pasta in root for pasta in ['.git', 'build', '.dart_tool', 'target', '.idea', 'node_modules']):
            continue
            
        for file in files:
            if file.endswith(EXTENSOES) and file != 'limpar_encoding.py':
                path = os.path.join(root, file)
                try:
                    # Tenta ler com UTF-8 primeiro, se falhar tenta Latin-1 / Windows-1252
                    try:
                        with open(path, 'r', encoding='utf-8') as f:
                            conteudo = f.read()
                    except UnicodeDecodeError:
                        with open(path, 'r', encoding='latin-1') as f:
                            conteudo = f.read()
                    
                    conteudo_novo = conteudo
                    for errado, correto in REPLACEMENTS.items():
                        conteudo_novo = conteudo_novo.replace(errado, correto)
                    
                    if conteudo != conteudo_novo:
                        with open(path, 'w', encoding='utf-8') as f:
                            f.write(conteudo_novo)
                        print(f"Corrigido: {path}")
                        ficheiros_corrigidos += 1
                except Exception as e:
                    print(f"Erro no ficheiro {path}: {e}")

    print(f"\nTotal de ficheiros atualizados: {ficheiros_corrigidos}")

if __name__ == "__main__":
    corrigir_ficheiros()