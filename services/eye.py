# Eye Pupil Detection
import cv2
import numpy
face_cascade = cv2.CascadeClassifier('./cascades/haarcascade_frontalface_default.xml')
eye_cascade = cv2.CascadeClassifier('./cascades/haarcascade_eye.xml')
cap = cv2.VideoCapture(0)

while True:
    # Capture frame-by-frame
    ret, frame = cap.read()

    # Convert to grayscale
    gray = cv2.cvtColor(frame, cv2.COLOR_BGR2GRAY)

    # Detect faces
    faces = face_cascade.detectMultiScale(gray, 1.3, 5)


    # Draw rectangle around the faces
    for (x, y, w, h) in faces:
        #cv2.rectangle(frame, (x,y), (x+w, y+h), (255,0,0), 2)
        roi_gray = gray[y:y+h, x:x+w]
        roi_color = frame[y:y+h, x:x+w]
        # Detect eyes
        eyes = eye_cascade.detectMultiScale(roi_gray)
        # Draw rectangle around the eyes
        for (ex, ey, ew, eh) in eyes:
            cv2.rectangle(roi_color, (ex,ey), (ex+ew, ey+eh), (0,255,0), 2)
            cv2.circle(roi_color, (int(ex+ew/2), int(ey+eh/2)), 2, (0,0,255), 2)
            cv2.circle(roi_color, (int(ex+ew/2), int(ey+eh/2)), int(eh/2), (0,0,255), 2)

    # Display the resulting frame
    cv2.imshow('Eye Pupil Detection', frame)

    # Press q to exit
    if cv2.waitKey(1) & 0xFF == ord('q'):
        break
    
    

cap.release()
cv2.destroyAllWindows()