import numpy as np
import cv2

eye_cascade = cv2.CascadeClassifier('./cascades/haarcascade_eye.xml')
cap = cv2.VideoCapture(0)

diameter = []
blink = False
bcount = -1
kernel = np.ones((5, 5), np.uint8)
global a
font = cv2.FONT_HERSHEY_SIMPLEX

# Adjust the threshold value as needed
threshold_value = 20
scale_w = 0
scale_h = 0
verified_frame = 0

try:
    while 1:
        ret, img = cap.read()
        gray = cv2.cvtColor(img, cv2.COLOR_BGR2GRAY)
        eyes = eye_cascade.detectMultiScale(gray, 1.1, 7)

        if len(eyes) > 0:
            a = "Eye Open"

            if blink == True:
                blink = False

            cv2.putText(img, a, (10, 30), font, 1, (0, 0, 255), 2, cv2.LINE_AA)

            for (ex, ey, ew, eh) in eyes:
                cv2.rectangle(img, (ex, ey), (ex + ew, ey + eh), (0, 255, 0), 2)  # Add bounding box around eyes

                # Calculate scale relative to the size of the webcam window
                scale_w = ew / img.shape[1]
                scale_h = eh / img.shape[0]

                cv2.putText(img, f"Scale (W): {scale_w:.2f}", (10, 100), font, 1, (0, 0, 255), 2, cv2.LINE_AA)
                cv2.putText(img, f"Scale (H): {scale_h:.2f}", (10, 130), font, 1, (0, 0, 255), 2, cv2.LINE_AA)

                roi_gray2 = gray[ey:ey + eh, ex:ex + ew]
                roi_color2 = img[ey:ey + eh, ex:ex + ew]
                blur = cv2.GaussianBlur(roi_gray2, (5, 5), 10)
                erosion = cv2.erode(blur, kernel, iterations=2)
                ret3, th3 = cv2.threshold(erosion, threshold_value, 255, cv2.THRESH_BINARY + cv2.THRESH_OTSU)
                circles = cv2.HoughCircles(erosion, cv2.HOUGH_GRADIENT, 4, 200, param1=20, param2=150, minRadius=0,
                                           maxRadius=0)
                try:
                    for i in circles[0, :]:
                        if (i[2] > 0 and i[2] < 55):
                            cv2.circle(roi_color2, (i[0], i[1]), i[2], (0, 0, 255), 1)
                            cv2.putText(img, "Pupil Pos:", (450, 30), font, 1, (0, 0, 255), 2, cv2.LINE_AA)
                            cv2.putText(img, "X " + str(int(i[0])) + " Y " + str(int(i[1])), (430, 60), font, 1,
                                        (0, 0, 255), 2, cv2.LINE_AA)
                            d = (i[2] / 2.0)
                            dmm = 1 / (25.4 / d)
                            diameter.append(dmm)
                            cv2.putText(img, str('{0:.2f}'.format(dmm)) + "mm", (10, 60), font, 1, (0, 0, 255), 2,
                                        cv2.LINE_AA)
                            cv2.circle(roi_color2, (i[0], i[1]), 2, (0, 0, 255), 3)
                            # cv2.imshow('erosion',erosion)
                except Exception as e:
                    pass
        else:
            if blink == False:
                blink = True
                if blink == True:
                    cv2.putText(img, "Blink", (10, 90), font, 1, (0, 0, 255), 2, cv2.LINE_AA)
            a = "Eye Close"
            cv2.putText(img, a, (10, 30), font, 1, (0, 0, 255), 2, cv2.LINE_AA)

        print(scale_h, scale_w)
        if (scale_h > 0.5 and scale_w > 0.4):
            verified_frame += 1
            print("VERIFIED", verified_frame)
        else:
            verified_frame = 0

        if (verified_frame >= 50):
            print("VERIFIED")
            verified_frame = 0
            break

        cv2.imshow('img', img)
        k = cv2.waitKey(30) & 0xff
        if k == 27:
            break
        

    cap.release()
    cv2.destroyAllWindows()

except Exception as e:
    cap.release()
    cv2.destroyAllWindows()
