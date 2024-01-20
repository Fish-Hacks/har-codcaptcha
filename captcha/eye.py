import numpy as np
import cv2

class EyeCaptcha:
    def __init__(self):
        self.eye_cascade = cv2.CascadeClassifier(cv2.data.haarcascades + 'haarcascade_eye.xml')
        self.cap = cv2.VideoCapture(0)
        self.diameter = []
        self.blink = False
        self.bcount = -1
        self.kernel = np.ones((5, 5), np.uint8)
        self.font = cv2.FONT_HERSHEY_SIMPLEX
        self.threshold_value = 20
        self.verified_frame = 0

        self.initThresholds = False
        self.verified_frame_threshold = 10
        self.w_init = 0
        self.h_init = 0
        self.w_threashold_offset = 0.18
        self.h_threashold_offset = 0.15

        self.succeeded = False


    def detect(self):
        try:
            while True:
                ret, img = self.cap.read()
                gray = cv2.cvtColor(img, cv2.COLOR_BGR2GRAY)
                eyes = self.eye_cascade.detectMultiScale(gray, 1.1, 7)

                if not self.initThresholds:
                    if len(eyes) > 0:
                        self.w_init = eyes[0, 2] / img.shape[1]
                        self.h_init = eyes[0, 3] / img.shape[0]
                        self.initThresholds = True

                        print("INITIAL W:", self.w_init)
                        print("INITIAL H:", self.h_init)
                        print("W THRESHOLD:", self.w_init + self.w_threashold_offset)
                        print("H THRESHOLD:", self.h_init + self.h_threashold_offset)

                if len(eyes) > 0:
                    self.blink = False
                    self.draw_eye_info(img, gray, eyes)
                    self.verify_eye_scale(img, eyes)
                else:
                    self.handle_eye_closed(img)

                if self.verified_frame >= self.verified_frame_threshold:
                    self.verified_frame = 0
                    self.succeeded = True
                    break

                cv2.imshow('img', img)
                k = cv2.waitKey(30) & 0xff
                if k == 27:
                    break

            self.cap.release()
            cv2.destroyAllWindows()
        except Exception as e:
            print(e)
            self.cap.release()
            cv2.destroyAllWindows()

    def draw_eye_info(self, img, gray, eyes):
        a = "Eye Open"
        cv2.putText(img, a, (10, 30), self.font, 1, (0, 0, 255), 2, cv2.LINE_AA)

        for (ex, ey, ew, eh) in eyes:
            cv2.rectangle(img, (ex, ey), (ex + ew, ey + eh), (0, 255, 0), 2)  # Add bounding box around eyes

            scale_w = ew / img.shape[1]
            scale_h = eh / img.shape[0]

            # print("Scale (W):", scale_w, self.w_init + self.w_threashold_offset)
            # print("Scale (H):", scale_h, self.h_init + self.h_threashold_offset)

            cv2.putText(img, f"Scale (W): {scale_w:.2f}", (10, 100), self.font, 1, (0, 0, 255), 2, cv2.LINE_AA)
            cv2.putText(img, f"Scale (H): {scale_h:.2f}", (10, 130), self.font, 1, (0, 0, 255), 2, cv2.LINE_AA)

            self.verify_pupil(img, gray, ey, eh, ex, ew)

    def verify_eye_scale(self, img, eyes):
        scale_h = eyes[0, 3] / img.shape[0]
        scale_w = eyes[0, 2] / img.shape[1] 

        if scale_h >= (self.h_init + self.h_threashold_offset) and scale_w > (self.w_init + self.w_threashold_offset):
            self.verified_frame += 1
            print("VERIFIED", self.verified_frame)
        else:
            self.verified_frame = 0

    def handle_eye_closed(self, img):
        if not self.blink:
            self.blink = True
            cv2.putText(img, "Blink", (10, 90), self.font, 1, (0, 0, 255), 2, cv2.LINE_AA)
        a = "Eye Close"
        cv2.putText(img, a, (10, 30), self.font, 1, (0, 0, 255), 2, cv2.LINE_AA)

    def verify_pupil(self, img, gray, ey, eh, ex, ew):
        roi_gray2 = gray[ey:ey + eh, ex:ex + ew]
        roi_color2 = img[ey:ey + eh, ex:ex + ew]
        blur = cv2.GaussianBlur(roi_gray2, (5, 5), 10)
        erosion = cv2.erode(blur, self.kernel, iterations=2)
        ret3, th3 = cv2.threshold(erosion, self.threshold_value, 255, cv2.THRESH_BINARY + cv2.THRESH_OTSU)
        circles = cv2.HoughCircles(erosion, cv2.HOUGH_GRADIENT, 4, 200, param1=20, param2=150, minRadius=0, maxRadius=0)

        try:
            for i in circles[0, :]:
                if 0 < i[2] < 55:
                    self.draw_pupil_info(img, roi_color2, i)
        except TypeError:
            pass

    def draw_pupil_info(self, img, roi_color2, i):
        center = (int(i[0]), int(i[1]))  # Convert center coordinates to integers
        radius = int(i[2])
        cv2.circle(roi_color2, center, radius, (0, 0, 255), 1)
        cv2.putText(img, "Pupil Pos:", (450, 30), self.font, 1, (0, 0, 255), 2, cv2.LINE_AA)
        cv2.putText(img, "X " + str(center[0]) + " Y " + str(center[1]), (430, 60), self.font, 1, (0, 0, 255), 2,
                    cv2.LINE_AA)
        d = (radius / 2.0)
        dmm = 1 / (25.4 / d)
        self.diameter.append(dmm)
        cv2.putText(img, str('{0:.2f}'.format(dmm)) + "mm", (10, 60), self.font, 1, (0, 0, 255), 2, cv2.LINE_AA)
        cv2.circle(roi_color2, center, 2, (0, 0, 255), 3)


eye = EyeCaptcha()
eye.detect()
