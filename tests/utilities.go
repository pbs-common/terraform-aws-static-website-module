package test

import "os"

func getFileAsString(fileName string) (string, error) {
	content, err := os.ReadFile(fileName)
	if err != nil {
		return "", err
	}

	text := string(content)
	return text, nil
}
