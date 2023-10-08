#!/bin/sh

if ! command -v 'zip' > /dev/null
then
    echo "zip(1) not found."
    exit 1
fi

if [ -z "${EDITOR}" ]
then
    echo 'EDITOR variable not set.'
    exit 1
fi
if ! command -v "${EDITOR}" > /dev/null
then
    echo "${EDITOR} not found."
    exit 1
fi

USAGE='Usage: epub-create [dir]'
if [ ! "${#}" -eq 1 ]
then
    echo "${USAGE}"
    exit 1
fi

create_epub () {
    WORK_DIR="${1}"
    OUT_FILE="${2}"
    (
        cd "${WORK_DIR}" \
            || { echo "Couldn't cd to ${WORK_DIR}, exiting."; exit 1; }
        # 'mimetype' must be first file in the zip archive.
        zip -X "${OUT_FILE}" mimetype > /dev/null;
        zip -urX "${OUT_FILE}" ./* > /dev/null;
    )
}

DIR="${1}"

printf %s 'Title? '
read -r TITLE
: "${TITLE:='A Document'}"
printf %s 'Authors? '
read -r AUTHORS
: "${AUTHORS:='[unknown]'}"
printf %s 'Language? '
read -r DOC_LANG
: "${DOC_LANG:='en'}"
printf %s 'Publication ID? '
read -r PUB_ID
: "${PUB_ID:='[unknown]'}"

FILES=$(ls -1 "${DIR}")
TMP_DIR="$(mktemp -d)"
SPINE="${TMP_DIR}/spine.txt"
EPUB="${TMP_DIR}/$DIR"
CONTAINER="${EPUB}/META-INF/container.xml"
PACKAGE="${EPUB}/EPUB/opf.opf"
NAV="${EPUB}/EPUB/nav.xhtml"

mkdir "${EPUB}"
mkdir "${EPUB}/META-INF"
mkdir "${EPUB}/EPUB"

# Create temporary spine file.
touch "${SPINE}"
for F in ${FILES}
do
    echo "${F}" >> "${SPINE}"
done

# Get user to finalise spine order.
"${EDITOR}" "${SPINE}"

# Create XHTML contents files.
for F in $(cat "${SPINE}")
do

    CONTENTS=$(cat "${DIR}"/"${F}")
    NAME="${EPUB}/EPUB/${F}"
    NAME=$(echo "${NAME}" | sed -e 's/\.[^.]*$//')
    touch "${NAME}.xhtml"
    cat >> "${NAME}.xhtml" << FIN
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml"
      xml:lang="${DOC_LANG}"
      lang="${DOC_LANG}">
  <head>
    <title>TITLE</title>
  </head>
  <body>
    <!-- START CONTENTS -->
    ${CONTENTS}
    <!-- END CONTENTS -->
  </body>
</html>
FIN

    # Get user to finalise file.
    "${EDITOR}" "${NAME}.xhtml"

done

# Create 'mimetype' file.
printf %s 'application/epub+zip' > "${EPUB}/mimetype"

# Create 'container.xml' file.
touch "${CONTAINER}"
cat >> "${CONTAINER}" << 'FIN'
<?xml version="1.0"?>
<container version="1.0"
           xmlns="urn:oasis:names:tc:opendocument:xmlns:container">
    <rootfiles>
        <rootfile full-path="EPUB/opf.opf"
            media-type="application/oebps-package+xml"/>
    </rootfiles>
</container>
FIN

# Create OPF file.
NOW=$(date -u '+%Y-%m-%dT%H:%M:%SZ')
touch "${PACKAGE}"
cat >> "${PACKAGE}" << FIN
<?xml version="1.0"?>
<package version="3.0"
         xml:lang="en"
         xmlns="http://www.idpf.org/2007/opf"
         unique-identifier="pub-id">
    <metadata xmlns:dc="http://purl.org/dc/elements/1.1/">
        <dc:identifier id="pub-id">${PUB_ID}</dc:identifier>
        <dc:title>${TITLE}</dc:title>
        <dc:creator id="creator">${AUTHORS}</dc:creator>
        <meta property="dcterms:modified">${NOW}</meta>
        <dc:language>${DOC_LANG}</dc:language>
    </metadata>
    <manifest>
        <item id="nav"
              href="nav.xhtml"
              media-type="application/xhtml+xml"
              properties="nav"/>
FIN
for F in $(cat "${SPINE}")
do
    NAME=$(echo "${F}" | sed -e 's/\.[^.]*$//')
    echo "        <item id=\"${NAME}\"" >> "${PACKAGE}"
    echo "              href=\"${NAME}.xhtml\"" >> "${PACKAGE}"
    echo '              media-type="application/xhtml+xml"/>' >> "${PACKAGE}"
done
echo '    </manifest>' >> "${PACKAGE}"
echo '    <spine>' >> "${PACKAGE}"
for F in $(cat "${SPINE}")
do
    NAME=$(echo "${F}" | sed -e 's/\.[^.]*$//')
    echo "        <itemref idref=\"${NAME}\"/>" >> "${PACKAGE}"
done
echo '    </spine>' >> "${PACKAGE}"
echo '</package>' >> "${PACKAGE}"

# Create 'nav.xhtml' file.
touch "${NAV}"
cat >> "${NAV}" << FIN
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml"
      xmlns:epub="http://www.idpf.org/2007/ops"
      xml:lang="${DOC_LANG}"
      lang="${DOC_LANG}">
  <head>
    <title>Table of Contents</title>
  </head>
  <body>
    <nav epub:type="toc">
      <h1>${TITLE}</h1>
      <ol>
FIN
for F in $(cat "${SPINE}")
do
    NAME=$(echo "${F}" | sed -e 's/\.[^.]*$//')
    echo '        <li>' >> "${NAV}"
    echo "          <a href=\"${NAME}.xhtml\">${NAME}</a>" >> "${NAV}"
    echo '        </li>' >> "${NAV}"
done
cat >> "${NAV}" << FIN
      </ol>
    </nav>
  </body>
</html>
FIN

# Get user to finalise 'nav.xhtml'.
"${EDITOR}" "${NAV}"

# Create EPUB.
if ! create_epub "${EPUB}" "${TMP_DIR}/${DIR}.epub"
then
    echo 'Zipping failed.'
    exit 1
fi

mv "${TMP_DIR}/${DIR}.epub" .
rm -rf "${TMP_DIR}"
echo "Created ${DIR}.epub."
exit 0

